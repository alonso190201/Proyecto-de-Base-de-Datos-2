--CREACION BASE DE DATOS
create database Farmacia2021

USE Farmacia2021

--CREACION DE TABLAS
create table usuario
(
cod_usu varchar(8)primary key not null,
cod_emp varchar(8)not null,
nivel_usu varchar(2)not null,
nom_usu varchar(30)not null,
apell_usu varchar(30)not null,
password varchar(10) not null,
activo varchar(2) not null
)
GO


CREATE table clientes
(
cod_cli varchar(8) primary key not null,
nom_cli varchar(40)not null,
apell_cli varchar(30)not null,
dir_cli varchar(40) null,
cod_dis varchar(8)null,
sexo varchar(1)not null,
DNI INT NULL,
RUC int null,
Telefono int null,
Celular int null
)
go


create table OrdenPedido
(
num_ordenPedido varchar(8) primary key not null,
fecha datetime not null,
cod_cli varchar (8) null,
nom_cli varchar(40)null,
apell_cli varchar(30)not null,
cod_emp varchar(8) null,
cod_tipoPago varchar(8) null,
total int null
)
go


create table distrito
(
cod_dis varchar(8)primary key not null,
nom_dis varchar(40) not null
)
go

INSERT INTO distrito (cod_dis,nom_dis)
VALUES 
('D1001','Gregorio Albarracín'),
('D1002','Ciudad Nueva'),
('D1003','Alto Alianza'),
('D1004','Tacna'),
('D1005','Pocollay');
go


create table categoria
(
cod_cate varchar(8)primary key not null,
nom_des varchar(40)not null
)
go

INSERT INTO categoria (cod_cate,nom_des)
VALUES 
('0020','Especialidades'),
('0021','Higiene Bucodental'),
('0022','Ortopedia'),
('0023','Costimos solares'),
('0024','Complemento infantil');
go

create table Producto
(
cod_pro varchar(8)primary key not null,
nom_pro varchar(40)not null,
pre_venta decimal(10,2) not null,
pre_compra decimal(10,2) not null,
fecha_venc datetime not null,
stock int not null,
cod_cate varchar(8)not null,
cod_prov varchar(8)null,
cod_pres varchar(8)null
)
go


create table empleado
(
cod_emp varchar(8)primary key not null,
nom_emp varchar(40)not null,
apell_emp varchar(30)not null,
dir_emp varchar(40)null,
cod_dis varchar(8)not null,
cargo varchar(40) not null,
edad varchar(2)null,
tel int not null,
cel int null,
ingreso datetime not null,
clave varchar (20) not null,
)
go


create table DetalleOrdenPedido
(
num_ordenp varchar(8)primary key not null,
cod_pro varchar(8) not null,
nom_pro varchar(40) not null,
cantidad decimal(10,2)null,
precio_venta decimal(10,2),
importe decimal(10,2)
)
GO


create table boleta
(
num_boleta varchar(8) primary key not null,
fecha datetime not null,
cod_empl varchar(8) not null,
cod_cli varchar(8)not null,
num_ordenpedido varchar(8)not null,
subtotal int not null,
descuento int null,
total int not null
)
go


create table presentacion
(
cod_pre varchar(8)primary key not null,
nom_pre varchar(50)null,
)
go

INSERT INTO presentacion (cod_pre,nom_pre)
VALUES 
('P500','Tabletas'),
('P501','Pastillas'),
go



create table proveedor
(
cod_prov varchar(8)primary key not null,
nom_prov varchar(40)not null,
dir_prov varchar(50)null,
telefono char(6)null,
celular char(9)null,
id_distrito varchar(8)null
)
go

--ALTER TABLE proveedor ALTER COLUMN telefono char(6)null;
INSERT INTO proveedor (cod_prov,nom_prov,dir_prov,telefono,celular,id_distrito)
VALUES 
('P0001','TecnoFarma','Dirección 1','123456','111111111','D1001'),
('P0002','Labofar','Dirección 2','123456','111111111','D1001'),
('P0003','Induquimica','Dirección 3','123456','111111111','D1002'),
('P0004','Medrock','Dirección 4','123456','111111111','D1002'),
('P0005','Loreal','Dirección 5','123456','111111111','D1002');
go


--RESTRICCIONES CLAVES SECUNDARIAS
alter table ordenpedido
add constraint pk_cod_cli
foreign key(cod_cli)
references clientes(cod_cli)
go

alter table clientes
add constraint pk_cod_dis_cli
foreign key (cod_dis)
references distrito(cod_dis)
go

alter table producto
add constraint pk_cod_cate
foreign key(cod_cate)
references categoria(cod_cate)
go

alter table empleado
add constraint pk_cod_dis
foreign key (cod_dis)
references distrito(cod_dis)
go

alter table ordenpedido
add constraint pk_cod_enpL
foreign key (cod_emp)
references empleado(cod_emp)
go

alter table ordenpedido
add constraint pk_cod_clis
foreign key(cod_cli)
references clientes(cod_cli)
go

alter table detalleordenPedido
add constraint pk_cod_pro
foreign key (cod_pro)
references producto(cod_pro)
go

alter table boleta
add constraint pk_or_pedi
foreign key (num_ordenpedido)
references ordenpedido(num_ordenpedido)
go

alter table ordenpedido
add constraint pk_cod_empl
foreign key (cod_emp)
references empleado(cod_emp)
go

alter table producto
add constraint pk_cod_prove
foreign key(cod_prov)
references proveedor(cod_prov)
go

alter table producto
add constraint pk_cod_presentacion
foreign key(cod_pres)
references presentacion(cod_pre)
go

alter table usuario
add constraint pk_cod_emple
foreign key(cod_emp)
references empleado(cod_emp)
go

alter table proveedor
add constraint pk_cod_dis_pro
foreign key(id_distrito)
references distrito(cod_dis)
go

--RESTRICIONES VALORES UNICOS
alter table distrito
add constraint uni_distrito
unique(nom_dis)
go

alter table clientes
add constraint uni_dni
unique(dni)
go

--RESTRICCIONES VALIDACION DE CAMPOS
alter table clientes
add constraint CK_DNI
CHECK(LEN(dni)=8)
go

alter table clientes
add constraint CK_SEXO
CHECK(SEXO IN('M','F'))
GO




--Procedimientos Almacenados:

--1. Procedimiento almacenado P_VERCLIENTES
CREATE OR ALTER PROCEDURE P_VERCLIENTES
AS
 SELECT cod_cli, nom_cli, DNI FROM dbo.Clientes
GO
-- Ejecutamos el procedimiento
EXEC P_VERCLIENTES


--2. El siguiente procedimiento almacenado
--sólo devuelve el cliente especificado
IF OBJECT_ID ( 'Farmacia.clientesparam', 'P' ) IS NOT NULL
 DROP PROCEDURE Farmacia.clientesparam
GO
CREATE PROCEDURE clientesparam
 @nombre varchar(70),
 @DNI varchar(50)
AS
 SELECT nom_cli, dir_cli,DNI,sexo
 FROM dbo.Clientes
 WHERE nom_cli = @nombre AND DNI = @DNI
GO
-- EJECUTAR EL PROCEDIMIENTO
EXECUTE clientesparam 'Herminia Japura Quispe', 72853131
GO

--3. CREAR UN PROCEDIMIENTO PARA INSERTAR UN CLIENTE
CREATE OR ALTER PROCEDURE INSERTACLIENTE
@cod_cli varchar(8),
@nom_cli varchar(40),
@dir_cli varchar(40),
@cod_dis varchar(8), --fk
@sexo varchar(1),
@DNI INT,
@RUC int,
@Telefono int,
@Celular int
AS
insert into clientes
values(@cod_cli,@nom_cli,@dir_cli,@cod_dis,@sexo,@DNI,@RUC,@Telefono,@Celular)
GO
--MANDAR A EJECUTAR EL PROCEDIMIENTO
EXECUTE INSERTACLIENTE 'C11000', 'Herminia Japura Quispe','Las Vegonias N-23, Edificio 23','D1004','F',72853131,1072853131,123456,234567890
GO 
SELECT * FROM clientes


--4. PROCEDIMIENTO INSERTAR REGISTROS EN PRODUCTO, UTILIZANDO PARAMETROS
CREATE OR ALTER PROCEDURE INSERTARPRODUCTOPARAM
@cod_pro varchar(8),
@nom_pro varchar(40),
@pre_venta decimal(10,2),
@pre_compra decimal(10,2),
@fecha_venc datetime,
@stock int,
@cod_cate varchar(8),
@cod_prov varchar(8),
@cod_pres varchar(8)
AS
insert into Producto
values(@cod_pro,@nom_pro,@pre_venta,@pre_compra,@fecha_venc,@stock,@cod_cate,@cod_prov,@cod_pres)
GO
--MANDAR A EJECUTAR EL PROCEDIMIENTO
EXECUTE INSERTARPRODUCTOPARAM '000003', 'LORAZEPAN DE 500MG',4,4.2,'10/10/2022',120,'0020','P0001','P501'
GO 
 select * from Producto


--5.PROCEDIMIENTO PARA ACTUALIZAR EL PRECIO DE CIERTOS PRODUCTOS
CREATE or ALTER PROCEDURE ACTUALIZARPRECIO
@cod_prod VARCHAR (8),
@pre_venta DECIMAL(10,2)
AS
UPDATE Producto
SET
pre_venta=@pre_venta where cod_pro=@cod_prod
GO
-- MANDAR A LLAMAR AL PREOCEDIMIENTO
EXECUTE ACTUALIZARPRECIO'000003', 250
GO

select * from Producto


--6. buscador de datos duplicados
 WITH C AS
 (
  SELECT cod_pre,nom_pre,
  ROW_NUMBER() OVER (PARTITION BY 
                    nom_pre
                    ORDER BY cod_pre) AS DUPLICADO
  FROM presentacion 
 )
 SELECT * FROM C 
 WHERE DUPLICADO > 1

--7. eliminando registros duplicados
 WITH C AS
 (
  SELECT cod_pre,nom_pre,
  ROW_NUMBER() OVER (PARTITION BY 
                    nom_pre
                    ORDER BY cod_pre) AS DUPLICADO
  FROM presentacion
 )
 DELETE FROM C 
 WHERE DUPLICADO > 1

 select * from presentacion

 --8. creador de usuario.
 create login Crow with password='contraseña' must_change,
 default_database=[Farmacia2021],
 default_language=[español],
 check_expiration=on, check_policy=on
 go
 create user Crow for login Crow
 go
 grant update on OrdenPedido to Crow
 grant insert on OrdenPedido to Crow
 grant delete on OrdenPedido to Crow
 go
 --actualizar
 CREATE or ALTER PROCEDURE actualizardato
@cod_cate VARCHAR (8),
@nom_des varchar(40)
AS
UPDATE categoria
SET
cod_cate=@cod_cate where nom_des=@nom_des
GO
-- MANDAR A LLAMAR AL PREOCEDIMIENTO
EXECUTE actualizardato'0029', 'prueba exitosa'
GO
 --ingresar
 INSERT INTO categoria (cod_cate,nom_des)
VALUES 
('0025','Especialidades'),
('0026','Higiene Bucodental'),
('0027','Ortopedia'),
('0028','Costimos solares'),
('0029','Complemento infantil');
go

--eliminar
delete from categoria where cod_cate = '0029'
select * from categoria

create table categoria
(
cod_cate varchar(8)primary key not null,
nom_des varchar(40)not null
)
go

