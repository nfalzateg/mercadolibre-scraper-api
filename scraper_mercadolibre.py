from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.keys import Keys
from typing import List, Dict
import time
import os
import urllib.parse

def get_driver():
    """
    Crea y configura el driver de Selenium para Chrome
    Configurado para funcionar en modo headless (sin interfaz gráfica)
    """
    chrome_options = Options()
    
    # Configuración para modo headless (necesario para EC2)
    chrome_options.add_argument('--headless')
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--disable-dev-shm-usage')
    chrome_options.add_argument('--disable-gpu')
    chrome_options.add_argument('--window-size=1920,1080')
    chrome_options.add_argument('--disable-blink-features=AutomationControlled')
    chrome_options.add_argument('user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36')
    
    # Si está en producción (EC2), usar el driver del sistema
    if os.getenv('ENVIRONMENT') == 'production':
        driver = webdriver.Chrome(options=chrome_options)
    else:
        # Para desarrollo local, puedes especificar la ruta del chromedriver si es necesario
        driver = webdriver.Chrome(options=chrome_options)
    
    return driver

def scrape_mercadolibre(query: str = "productos farmaceuticos") -> List[Dict[str, str]]:
    """
    Hace scraping de productos de MercadoLibre usando Selenium
    
    Args:
        query: Término de búsqueda
        
    Returns:
        Lista de diccionarios con información de productos
    """
    driver = None
    try:
        # Codificar la query para la URL de búsqueda de MercadoLibre
        query_encoded = urllib.parse.quote_plus(query)
        url = f"https://listado.mercadolibre.com.co/{query_encoded}"
        
        # Inicializar el driver
        driver = get_driver()
        driver.set_page_load_timeout(30)
        driver.get(url)
        
        # Esperar a que la página cargue
        wait = WebDriverWait(driver, 15)
        
        # Esperar a que aparezcan los productos
        try:
            wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, "li.ui-search-layout__item, div.ui-search-result")))
        except:
            # Si no encuentra con esos selectores, esperar un poco más
            time.sleep(3)
        
        # Scroll para cargar más productos
        driver.execute_script("window.scrollTo(0, document.body.scrollHeight/2);")
        time.sleep(2)
        driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
        time.sleep(2)
        
        productos = []
        
        # Intentar diferentes selectores según la estructura de MercadoLibre
        selectors = [
            "li.ui-search-layout__item",
            "div.ui-search-result",
            "div[class*='ui-search-result']",
            "ol.ui-search-layout__item"
        ]
        
        elementos_productos = []
        for selector in selectors:
            elementos = driver.find_elements(By.CSS_SELECTOR, selector)
            if elementos:
                elementos_productos = elementos
                break
        
        if not elementos_productos:
            # Fallback: buscar cualquier elemento que contenga información de producto
            elementos_productos = driver.find_elements(By.CSS_SELECTOR, "div[data-testid], li[data-testid]")
        
        for elemento in elementos_productos[:50]:  # Limitar a 50 productos
            try:
                # Buscar nombre del producto
                nombre = None
                nombre_selectors = [
                    "h2.ui-search-item__title",
                    "h2[class*='title']",
                    "a.ui-search-item__group__element",
                    "h3[class*='title']"
                ]
                for sel in nombre_selectors:
                    try:
                        nombre_elem = elemento.find_element(By.CSS_SELECTOR, sel)
                        nombre = nombre_elem.text.strip()
                        break
                    except:
                        continue
                
                # Buscar precio
                precio = "No disponible"
                precio_selectors = [
                    "span.andes-money-amount__fraction",
                    "span[class*='price']",
                    "span[class*='money']",
                    ".ui-search-price__second-line .price-tag-fraction"
                ]
                for sel in precio_selectors:
                    try:
                        precio_elem = elemento.find_element(By.CSS_SELECTOR, sel)
                        precio = precio_elem.text.strip()
                        break
                    except:
                        continue
                
                # Buscar link
                link = None
                link_selectors = [
                    "a.ui-search-link",
                    "a[class*='link']",
                    "a[href*='/MLA-']",
                    "a"
                ]
                for sel in link_selectors:
                    try:
                        link_elem = elemento.find_element(By.CSS_SELECTOR, sel)
                        link = link_elem.get_attribute('href')
                        if link and 'mercadolibre' in link:
                            break
                    except:
                        continue
                
                # Buscar imagen
                imagen = ""
                imagen_selectors = [
                    "img.ui-search-result-image__element",
                    "img[class*='image']",
                    "img"
                ]
                for sel in imagen_selectors:
                    try:
                        imagen_elem = elemento.find_element(By.CSS_SELECTOR, sel)
                        imagen = imagen_elem.get_attribute('src') or imagen_elem.get_attribute('data-src') or ""
                        if imagen:
                            break
                    except:
                        continue
                
                if nombre and link:
                    producto = {
                        'nombre': nombre,
                        'precio': precio,
                        'link': link,
                        'imagen': imagen
                    }
                    productos.append(producto)
                    
            except Exception as e:
                print(f"Error procesando producto: {e}")
                continue
        
        return productos
        
    except Exception as e:
        print(f"Error en scraping: {e}")
        raise Exception(f"Error al procesar MercadoLibre: {str(e)}")
    finally:
        if driver:
            driver.quit()

