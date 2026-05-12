## Ejercicio 4 (Una clave y un secreto en AES)

### Objetivo

Encontrar una clave de 50 caracteres generada desde un texto oculto, identificar su hash correcto entre 100 opciones (archivo hashes.txt) y descifrar un mensaje cifrado con AES-GCM.

Lo que tienes:
- Un texto con ruido y símbolos (file.txt)
- Una lista de 100 hashes SHA-256 (hashes.txt)
- Un mensaje cifrado en AES-GCM (hex) también el código de descifrado AES-GCM. (cipher.txt)

Tareas:
1. Extracción desde el texto
    
    Debes procesar el texto siguiendo estas reglas:

- Considera **solo letras (a–z, A–Z)**  
- El texto debe interpretarse como **cíclico (loop infinito)**  
- Usa índices basados en **números primos**  
- Aplica un desplazamiento: **(índice primo - 2)**  


2. Construcción de la clave
    
    Debes construir una clave de:
- **50 caracteres**
- Usando los caracteres extraídos del texto siguiendo las reglas anteriores.

3. Reglas adicionales para la clave:
- Si la palabra se termina, vuelve a empezar desde el inicio
- La mezcla entre texto y palabra base es obligatoria

4. Selección del hash correcto:
- Calcula SHA-256 de tu clave
- Compara contra la lista de 50 hashes (hashes.txt)
- Solo uno es válido

5. Descifrado AES-GCM

    Una vez encontrada la clave correcta:

- Convierte la clave a hash SHA-256 (32 bytes)
- El mensaje cifrado está en formato HEX
- AES-GCM requiere el nonce separado correctamente


💡 Pistas (CTF hints)

### 🟢 Nivel 1

> No necesitas leer el texto como historia.

### 🟡 Nivel 2

> Los números primos no son decoración, son índices.

### 🟠 Nivel 3

> El texto no tiene final útil: se comporta como un ciclo infinito.

### 🔴 Nivel 4

> Una palabra clave está escondida dentro del proceso de construcción: **kevinmitnick**

### 🧠 Nivel 5 (código hint)
Si estás atascado, piensa en este flujo:

```python
texto -> normalizar -> filtrar letras
-> índices primos
-> acceso circular
-> construcción de clave (50 chars)
-> inserción de palabra base cíclica
-> SHA-256
-> comparar hashes
-> AES-GCM decrypt
```

Código para descifrado AES-GCM:

```python
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
import os
import hashlib


# Función para derivar la clave a 32 bytes usando SHA-256
def derive_key(key):
    return hashlib.sha256(key.encode()).digest()

# Función para descifrar el mensaje usando AES-GCM

def decrypt_gcm(data, key):
    key_bytes = derive_key(key)
    aesgcm = AESGCM(key_bytes)

    nonce = data[:12]
    ciphertext = data[12:]

    return aesgcm.decrypt(nonce, ciphertext, None).decode()

key = "algunhash"
mensaje = "123"
cipher_hex = "Texto cifrado en hexadecimal aquí"
cipher_bytes = bytes.fromhex(cipher_hex)

dec = decrypt_gcm(cipher_bytes, clave)
print(dec)

print("DESCIFRADO:", dec)
```

### Hint final
```python
import hashlib
import random
import unicodedata
import math

def es_primo(n):
    if n < 2:
        return False
    for i in range(2, int(math.sqrt(n)) + 1):
        if n % i == 0:
            return False
    return True

def primos_indices(n):
    return [i for i in range(n) if es_primo(i)]
```

**Ojo**: No se vale usar fuerza bruta para encontrar la clave, el proceso de extracción y construcción es parte del desafío.