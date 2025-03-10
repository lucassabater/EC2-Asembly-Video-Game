from PIL import Image

def convertir_a_asm(imagen, ancho, alto):
    asm_codigo = []


    for y in range(alto):
        fila = []  # Almacena los colores de la fila actual
        for x in range(ancho):
            # Obtener el color del píxel en formato RGB
            color = imagen.getpixel((x, y))

            # Convertir el color a formato $00BBGGRR
            color_asm = (color[2] << 16) | (color[1] << 8) | color[0]

            # Formatear el color como hexadecimal
            fila.append(f"$00{color_asm:06X}")

            # Si llegamos a 16 colores, agregamos una línea ensamblador
            if len(fila) == 16:
                asm_codigo.append(f"    DC.L {', '.join(fila)}")
                fila = []  # Reiniciar la fila para los siguientes colores

        # Si quedan colores en la fila, los agregamos
        if fila:
            asm_codigo.append(f"    DC.L {', '.join(fila)}")

    return asm_codigo


def guardar_en_archivo(codigo_asm):
    with open('output.asm', 'w') as archivo:
        for instruccion in codigo_asm:
            archivo.write(instruccion + '\n')

def main():
    # Ruta de la imagen
    ruta_imagen = 'pantallaInicio.png'

    # Abrir la imagen
    imagen = Image.open(ruta_imagen)

    # Obtener dimensiones de la imagen
    ancho, alto = imagen.size

    print(f"ancho: {ancho}, alto: {alto}")

    # Convertir la imagen a código ensamblador m68k
    codigo_asm = convertir_a_asm(imagen, ancho, alto)

    # Guardar el código ensamblador en un archivo
    guardar_en_archivo(codigo_asm)

if __name__ == "__main__":
    main()
