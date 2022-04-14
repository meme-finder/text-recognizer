from typing import Optional
from fastapi import FastAPI
from pydantic import BaseModel
from fastapi.encoders import jsonable_encoder
import uuid


app = FastAPI()


@app.post("/")
async def recognize_image() -> int:
    return 0
