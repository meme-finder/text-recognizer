from fastapi import FastAPI, UploadFile
from PIL import Image
import pytesseract
import io


app = FastAPI()
print(pytesseract.get_languages(config=''))


@app.post("/")
async def recognize_image(file: UploadFile) -> str:
    content = await file.read()
    image = Image.open(io.BytesIO(content))
    text = pytesseract.image_to_string(image, lang='osd')
    return text
