-- Motor utilizado: SQL Server
-- Proyecto RetailPro - M4: consultas de negocio
-- Base: Ventas_Tech_DB (la que arme en M3)

-- === CONSULTA 1: RESUMEN EJECUTIVO MENSUAL ===
-- total facturado, cantidad de pedidos y ticket promedio por mes
select
month(fecha_venta) as mes,
sum(cantidad * precio_unitario) as total_facturado,
count(*) as cantidad_pedidos,
cast(avg(cantidad * precio_unitario) as decimal(10,2)) as ticket_promedio
from ventas
group by month(fecha_venta);


-- === CONSULTA 2: RANKING DE PRODUCTOS ===
-- top 5 de productos que mas facturaron
select top 5
id_producto,
sum(cantidad) as unidades_vendidas,
sum(cantidad * precio_unitario) as total_facturado
from ventas
group by id_producto
order by total_facturado desc;


-- === CONSULTA 3: CLIENTES RECURRENTES ===
-- clientes que hicieron mas de un pedido
select
id_cliente,
count(*) as cantidad_pedidos,
sum(cantidad * precio_unitario) as total_gastado
from ventas
group by id_cliente
having count(*) > 1
order by total_gastado desc;


-- === CONSULTA 4: MESES POR ENCIMA / POR DEBAJO DEL PROMEDIO ===
-- el (select avg...) de adentro calcula el promedio mensual general
select
month(fecha_venta) as mes,
sum(cantidad * precio_unitario) as total_facturado,
case
when sum(cantidad * precio_unitario) > (select avg(total_mes) from (select sum(cantidad * precio_unitario) as total_mes from ventas group by month(fecha_venta)) as meses) then 'Por encima'
when sum(cantidad * precio_unitario) < (select avg(total_mes) from (select sum(cantidad * precio_unitario) as total_mes from ventas group by month(fecha_venta)) as meses) then 'Por debajo'
else 'En el promedio'
end as comparacion_promedio
from ventas
group by month(fecha_venta);


-- === HALLAZGOS ===
-- 1) El producto 1 concentra mas de la mitad de la facturacion: 3600 de un total de 6444 (aprox 56%).
-- 2) El producto 2 es el que mas unidades vendio (13) pero factura poco: 364, solo el 5,6% del total.
-- 3) Los 5 clientes compraron 2 veces, y el cliente 1 es el que mas gasto: 2640 (aprox 41% del total).
