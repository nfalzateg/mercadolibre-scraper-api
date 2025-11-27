from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
import scraper_mercadolibre
from datetime import datetime
import logging
import traceback

# Configurar logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

app = FastAPI(
    title="MercadoLibre Scraper API",
    description="API para hacer scraping de productos de MercadoLibre",
    version="1.0.0"
)

# Configurar CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Modelo para el producto
class Producto(BaseModel):
    nombre: str
    precio: str
    link: str
    imagen: Optional[str] = None

# Modelo para la respuesta
class ScrapeResponse(BaseModel):
    success: bool
    query: str
    total: int
    productos: List[Producto]
    timestamp: str

@app.get("/")
async def root():
    """Endpoint raíz"""
    return {
        "message": "MercadoLibre Scraper API",
        "version": "1.0.0",
        "docs": "/docs"
    }

@app.get("/health")
async def health_check():
    """Verificar estado del servicio"""
    return {
        "status": "ok",
        "timestamp": datetime.now().isoformat()
    }

@app.get("/api/scrape", response_model=ScrapeResponse)
async def scrape_mercadolibre_endpoint(
    query: str = Query(
        default="productos farmaceuticos",
        description="Término de búsqueda",
        min_length=1,
        max_length=200
    ),
    limit: Optional[int] = Query(
        default=None,
        description="Límite de productos",
        ge=1,
        le=100
    )
):
    """
    Hace scraping de productos de MercadoLibre
    
    Permite buscar cualquier producto escribiendo el término de búsqueda.
    Retorna una lista de productos con nombre, precio, link e imagen.
    """
    try:
        logger.info(f"Iniciando scraping para query: {query}")
        productos = scraper_mercadolibre.scrape_mercadolibre(query)
        
        if not productos:
            logger.warning(f"No se encontraron productos para la búsqueda: {query}")
            return ScrapeResponse(
                success=True,
                query=query,
                total=0,
                productos=[],
                timestamp=datetime.now().isoformat()
            )
        
        if limit and limit < len(productos):
            productos = productos[:limit]
        
        logger.info(f"Scraping completado. Productos encontrados: {len(productos)}")
        return ScrapeResponse(
            success=True,
            query=query,
            total=len(productos),
            productos=productos,
            timestamp=datetime.now().isoformat()
        )
    except Exception as e:
        logger.error(f"Error al hacer scraping: {str(e)}")
        logger.error(traceback.format_exc())
        raise HTTPException(
            status_code=500,
            detail=f"Error al hacer scraping: {str(e)}"
        )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

