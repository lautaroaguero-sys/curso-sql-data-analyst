-- Motor utilizado: SQL Server (lo probe en sqlfiddle recomendado por ticher)

-- === SECCIÓN 1: DROP ===
-- primero borro las que tienen fk sino se queja
drop table if exists ventas;
drop table if exists productos;
drop table if exists clientes;
drop table if exists categorias;

-- === SECCIÓN 2: CREATE ===
-- ahora las creo al reves, primero las que no dependen de nadie

create table categorias (
id_categoria int primary key,
nombre_categoria varchar(50) not null,
descripcion varchar(200)
);

create table clientes (
id_cliente int primary key,
nombre varchar(100) not null,
email varchar(100) unique,
ciudad varchar(50),
fecha_registro date not null
);

-- esta depende de categorias
create table productos (
id_producto int primary key,
nombre_producto varchar(100) not null,
id_categoria int foreign key references categorias(id_categoria),
precio decimal(10,2) not null,
stock int default 0,
activo bit default 1
);

-- esta va ultima porque necesita clientes y productos
create table ventas (
id_venta int primary key,
id_cliente int foreign key references clientes(id_cliente),
id_producto int foreign key references productos(id_producto),
cantidad int not null,
precio_unitario decimal(10,2) not null,
fecha_venta date not null
);

-- === SECCIÓN 3: INSERT ===
-- la N de adelante es para que no se rompan las tildes

-- categorias (4)
insert into categorias (id_categoria, nombre_categoria, descripcion) values
(1, N'Computación', N'Laptops, PCs y monitores'),
(2, N'Accesorios', N'Periféricos y complementos'),
(3, N'Audio', N'Auriculares y parlantes'),
(4, N'Almacenamiento', N'Discos y memorias');

-- clientes (5)
insert into clientes (id_cliente, nombre, email, ciudad, fecha_registro) values
(1, N'María López', 'maria@mail.com', N'Buenos Aires', '2024-01-05'),
(2, N'Carlos Ruiz', 'carlos@mail.com', N'Córdoba', '2024-01-10'),
(3, N'Ana Gómez', 'ana@mail.com', N'Rosario', '2024-02-01'),
(4, N'Pedro Sanz', 'pedro@mail.com', N'Mendoza', '2024-02-15'),
(5, N'Laura Torres', 'laura@mail.com', N'Tucumán', '2024-03-01');

-- productos (6)
insert into productos (id_producto, nombre_producto, id_categoria, precio, stock, activo) values
(1, N'Laptop Pro 15', 1, 1200.00, 15, 1),
(2, N'Mouse Inalámbrico', 2, 28.00, 80, 1),
(3, N'Monitor 4K 27', 1, 450.00, 12, 1),
(4, N'Auriculares BT Pro', 3, 120.00, 35, 1),
(5, N'SSD Externo 1TB', 4, 130.00, 18, 1),
(6, N'Teclado Mecánico', 2, 95.00, 40, 1);

-- ventas (10)
insert into ventas (id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) values
(1, 1, 1, 2, 1200.00, '2024-03-05'),
(2, 2, 2, 5, 28.00, '2024-03-06'),
(3, 3, 3, 1, 450.00, '2024-03-07'),
(4, 1, 4, 2, 120.00, '2024-03-08'),
(5, 4, 5, 3, 130.00, '2024-03-10'),
(6, 2, 6, 4, 95.00, '2024-03-11'),
(7, 5, 1, 1, 1200.00, '2024-03-12'),
(8, 3, 2, 8, 28.00, '2024-03-13'),
(9, 4, 4, 1, 120.00, '2024-03-14'),
(10, 5, 3, 2, 450.00, '2024-03-15');

-- === SECCIÓN 4: VALIDACIÓN ===
-- a ver si estan todos los datos
select * from categorias; -- tienen que ser 4
select * from clientes; -- 5
select * from productos; -- 6
select * from ventas; -- 10
