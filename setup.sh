#!/bin/bash

./clean_stack.sh

./install_stack.sh
if [ $? -ne 0 ]; then
    echo "Error al ejecutar install_stack.sh. Saliendo..."
    exit 1
fi

sleep 30

source venv/bin/activate
if [ $? -ne 0 ]; then
    echo "Error al activar el entorno virtual. Saliendo..."
    exit 1
fi
pip install -r requirements.txt
# Cambiar al directorio create_data
cd deploy_dao/
if [ $? -ne 0 ]; then
    echo "Error al cambiar al directorio create_data. Saliendo..."
    exit 1
fi

# Ejecutar el script create.py con Python 3.10
python3.10 create_daos.py
if [ $? -ne 0 ]; then
    echo "Error al ejecutar create.py. Saliendo..."
    exit 1
fi


cd ../demo_devices/
if [ $? -ne 0 ]; then
    echo "Error al cambiar al directorio create_data. Saliendo..."
    exit 1
fi

# Levantar contenedores de devices
docker compose up --build -d
if [ $? -ne 0 ]; then
    echo "Error al levantar contenedores de Devices. Saliendo..."
    exit 1
fi

sleep 30

# Ejecutar el script create.py con Python 3.10
python3.10 configure_devices.py
if [ $? -ne 0 ]; then
    echo "Error al ejecutar configure_devices.py. Saliendo..."
    exit 1
fi

cd ../populate_algorithms/
if [ $? -ne 0 ]; then
    echo "Error al cambiar al directorio populate_algorithms. Saliendo..."
    exit 1
fi

python3.10 populate.py
if [ $? -ne 0 ]; then
    echo "Error al ejecutar populate.py (algorithms). Saliendo..."
    exit 1
fi

cd ../populate_devices/
if [ $? -ne 0 ]; then
    echo "Error al cambiar al directorio populate_devices. Saliendo..."
    exit 1
fi

python3.10 populate.py
if [ $? -ne 0 ]; then
    echo "Error al ejecutar populate.py (devices). Saliendo..."
    exit 1
fi


echo "Todos los pasos se ejecutaron correctamente. Stack UP!!!"
