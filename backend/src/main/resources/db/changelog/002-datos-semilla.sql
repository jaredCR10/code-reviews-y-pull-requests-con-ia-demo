-- Datos de ejemplo del catálogo de insumos (RF-03), separados del esquema.
INSERT INTO insumos (id, nombre, existencia, precio_unitario) VALUES
    (UUID(), 'Aceite de motor 10W-40 (litro)', 40, 6500.00),
    (UUID(), 'Filtro de aceite',               25, 4200.00),
    (UUID(), 'Pastillas de freno (juego)',     12, 18500.00),
    (UUID(), 'Bujia',                          60, 3100.00);
