# 🏦 KipuBank Smart Contract

## 📘 Descripción del contrato

**KipuBank** es un contrato inteligente desarrollado en Solidity que simula un banco descentralizado básico en la blockchain de Ethereum.  
Su objetivo es permitir a los usuarios **depositar y retirar fondos (ETH)** dentro de ciertos límites configurados al momento del despliegue.

### ⚙️ Características principales
- Cada dirección de usuario tiene su propia **bóveda personal** (mapeada por su address).
- Existe un **límite máximo de retiro** por transacción (`i_MaxWithdraw`).
- Se define un **tope global de depósitos** (`i_bankCapGlobalAllowed`), que restringe la capacidad total del banco.
- Se lleva un registro del número de **depósitos y retiros** realizados.
- Los depósitos y retiros emiten eventos para ser monitoreados fácilmente.

### 🔐 Seguridad
- Las variables críticas son **inmutables** (`immutable`), lo que garantiza que los límites definidos no pueden modificarse después del despliegue.
- Los retiros fallidos lanzan un error personalizado `withdraw_TrasactationFail`.
- Solo el **propietario de los fondos** puede retirarlos.

---

## 🚀 Instrucciones de despliegue

1. **Abrir el contrato en Remix IDE**
   - Copia el código fuente del contrato `KipuBank.sol` en Remix.
   - Selecciona el compilador Solidity versión `0.8.30`.
   - Compila el contrato.

2. **Configurar los parámetros del constructor**
   El contrato requiere dos valores al momento del despliegue:
   - `_Max_Withdraw`: monto máximo permitido para retiro por transacción (en wei).
   - `_bankCapGlobalAllowed`: capacidad total global del banco (en wei).


3. **Elegir el entorno de ejecución**
- En Remix, selecciona “**Environment → Remix VM (Prague)**” o una red de prueba como **Sepolia**.
- Asegúrate de tener fondos suficientes (ETH de prueba).

4. **Desplegar el contrato**
- Haz clic en **Deploy** y confirma la transacción.
- Una vez desplegado, verás el contrato en el panel “Deployed Contracts”.

---

## 💬 Cómo interactuar con el contrato

### 1. Depositar fondos
- Usa la función `depositAmount()`.
- En Remix, en el campo **Value**, ingresa la cantidad de ETH (en wei) que deseas depositar.
- Presiona **transact**.
- Se emitirá el evento `Deposit_amountSaved(address user, uint256 amount)`.

### 2. Retirar fondos
- Usa la función `withdrawAmount(uint256 _amount)`.
- El monto ingresado debe ser:
- Mayor que cero.
- Menor que `i_MaxWithdraw`.
- Solo podrás retirar fondos que hayas depositado previamente.
- Si la transacción se completa, se emitirá el evento `Retire_InProcess`.

### 3. Consultar tu balance
- Llama a la función `_userBalance()`.
- Retorna el monto total de ETH depositado por el usuario que llama.

### 4. Consultar estadísticas globales
- Llama a la función `recordMovementTolta()`.
- Devuelve dos valores:
- Número total de depósitos realizados (`_deposit`).
- Número total de retiros (`_extraction`).

---

## 🧾 Eventos

| Evento | Descripción |
|--------|--------------|
| `Deposit_amountSaved(address user, uint256 amount)` | Se emite cuando un usuario deposita fondos. |
| `Retire_InProcess(address user, uint256 amount)` | Se emite cuando un usuario inicia un retiro. |

---

## 🧠 Autor
**Desarrollado por:** Dario Cesar Atach  
**Licencia:** MIT  
**Versión del compilador:** Solidity 0.8.30  
**Framework:** OpenZeppelin `Strings.sol` para manejo seguro de conversiones numéricas.

---


