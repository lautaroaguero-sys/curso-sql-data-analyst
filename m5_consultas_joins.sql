-- Motor utilizado: SQL Server
-- Proyecto RetailPro - M5: consultas con JOINs
-- Base: Ventas_Tech_DB (la de M3)

-- === DATOS EXTRA PARA PROBAR LOS LEFT JOIN ===
-- en M3 todos los clientes y productos tienen ventas, entonces las consultas 2 y 3
-- no devolverian nada. Agrego un cliente y un producto sin ventas
insert into clientes (id_cliente, nombre, email, ciudad, fecha_registro) values
(6, N'Sofía Díaz', 'sofia@mail.com', N'La Plata', '2024-03-20');

insert into productos (id_producto, nombre_producto, id_categoria, precio, stock, activo) values
(7, N'Webcam HD', 2, 60.00, 25, 1);


-- === CONSULTA 1: VISTA BASE (INNER JOIN) ===
-- ventas con el nombre del cliente, la ciudad, el producto y la categoria
select
v.fecha_venta,
v.id_cliente,
c.nombre as nombre_cliente,
c.ciudad,
p.nombre_producto,
cat.nombre_categoria,
v.cantidad,
v.precio_unitario,
v.cantidad * p.precio as total_venta
from ventas v
inner join clientes c on v.id_cliente = c.id_cliente
inner join productos p on v.id_producto = p.id_producto
inner join categorias cat on p.id_categoria = cat.id_categoria
order by v.fecha_venta;


-- === CONSULTA 2: CLIENTES SIN VENTAS (LEFT JOIN) ===
-- si no hay venta, las columnas de ventas vienen en null
select
c.nombre,
c.email,
c.fecha_registro
from clientes c
left join ventas v on c.id_cliente = v.id_cliente
where v.id_venta is null;


-- === CONSULTA 3: PRODUCTOS SIN VENTAS (LEFT JOIN) ===
select
p.nombre_producto,
cat.nombre_categoria,
p.precio
from productos p
inner join categorias cat on p.id_categoria = cat.id_categoria
left join ventas v on p.id_producto = v.id_producto
where v.id_venta is null;


-- === CONSULTA 4: CONSOLIDADO POR CANAL (UNION ALL) ===
-- no tengo una columna canal asi que la invento con un texto fijo en cada select
-- separe las ventas en dos quincenas de marzo
select canal, sum(total) as total_canal
from (
    select fecha_venta, cantidad * precio_unitario as total, 'Primera quincena' as canal
    from ventas
    where fecha_venta < '2024-03-11'
    union all
    select fecha_venta, cantidad * precio_unitario as total, 'Segunda quincena' as canal
    from ventas
    where fecha_venta >= '2024-03-11'
) as consolidado
group by canal;
