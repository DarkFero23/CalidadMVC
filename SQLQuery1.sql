---Creamos la base de datos carrito---------------
create database DBCARRITO

GO

Use DBCARRITO

GO
----------------------------------------

--------BEGIN Creacion de Tablas------------
CREATE TABLE CATEGORIA (
  IdCategoria INT PRIMARY KEY identity,
  Descripcion VARCHAR(100),
  Activo BIT DEFAULT 1,
  FechaRegistro DATETIME DEFAULT GETDATE()
)

go
select * from CATEGORIA

CREATE TABLE MARCA (
  IdMarca INT PRIMARY KEY identity,
  Descripcion VARCHAR(100),
  Activo BIT DEFAULT 1,
  FechaRegistro DATETIME DEFAULT GETDATE()
)
go

CREATE TABLE PRODUCTO (
  IdProducto INT PRIMARY KEY identity,
  Nombre VARCHAR(500),
  Descripcion VARCHAR(500),
  IdMarca INT REFERENCES MARCA(IdMarca),
  IdCategoria INT references Categoria(IdCategoria),
  Precio DECIMAL(10,2) DEFAULT 0,
  Stock INT,
  RutaImagen VARCHAR(100),
  NombreImagen VARCHAR(100),
  Activo BIT DEFAULT 1,
  FechaRegistro DATETIME DEFAULT GETDATE()
)
go
Drop table cliente 
CREATE TABLE CLIENTE (
  IdCliente INT PRIMARY KEY identity,
  Nombre VARCHAR(100),
  Apellidos VARCHAR(100),
  Correo VARCHAR(100),
  Clave VARCHAR(150),
  Reestablecer BIT DEFAULT 0,
  FechaRegistro DATETIME DEFAULT GETDATE()
)
GO

CREATE TABLE CARRITO (
  IdCarrito INT PRIMARY KEY identity,
  IdCliente INT REFERENCES CLIENTE(IdCliente),
  IdProducto INT REFERENCES PRODUCTO(IdProducto),
  Cantidad INT
)
GO
select * from venta

CREATE TABLE VENTA(
  IdVenta INT PRIMARY KEY identity,
  IdCliente INT REFERENCES CLIENTE(IdCliente),
  TotalProducto INT,
  MontoTotal DECIMAL(10,2),
  Contacto VARCHAR(50),
  IdDistrito VARCHAR(10),
  Telefono VARCHAR(50),
  Direccion VARCHAR(500),
  IdTransaccion VARCHAR(50),
  FechaVenta DATETIME DEFAULT GETDATE()
)
GO

Create TABLE DETALLE_VENTA(
	IdeDetalleVenta int primary key identity,
	IdVenta int references Venta(IdVenta),
	IdProducto int references Producto(IdProducto),
	Cantidad int,
	Total decimal(10,2)



)
GO
DROP TABLE USUARIO
Create Table USUARIO(
  IdUsuario int primary key identity,
  Nombres VARCHAR(100),
  Apellidos VARCHAR(100),
  Correo VARCHAR(100),
  Clave VARCHAR(150),
  Reestablecer BIT DEFAULT 1,
  Activo bit default 1,
  FechaRegistro DATETIME DEFAULT GETDATE()


)
GO

ALTER TABLE USUARIO
ADD CONSTRAINT DF_Reestablecer DEFAULT 1 FOR Reestablecer;

Create Table DEPARTAMENTO(
	IdDepartamento varchar(2) NOT NULL,
	Descripcion varchar(45) NOt NULL,

)
GO



Create Table PROVINCIA(
	IdProvincia varchar(4) NOT NULL,
	Descripcion varchar(45) NOt NULL,
	IdDepartamento varchar(2) Not Null
)
GO


Create Table DISTRITO(
	IdDistrito varchar(6) NOT NULL,
	Descripcion varchar(45) NOt NULL,
	IdProvincia varchar(4) NOT NULL,
	IdDepartamento varchar(2) Not Null
	
)
GO

-------COMMIT TABLAS----------------------

-----BEGIN Procedimiento para registrar usuario---
create proc sp_RegistrarUsuario(
@Nombres varchar(100),
@Apellidos varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin
	Set @Resultado=0
		IF NOT EXISTS (Select *from USUARIO WHERE Correo = @Correo)
		begin 
			insert into USUARIO(Nombres,Apellidos,Correo,Clave,Activo)values
			(@Nombres,@Apellidos,@Correo,@Clave,@Activo)

			Set @Resultado = SCOPE_IDENTITY()
		end
		else
			set @Mensaje = 'El correo del usuario ya existe'
end	


GO
-----------------PRUEBA DE PROC----------
DECLARE @Mensaje varchar(500)
DECLARE @Resultado int
---------COMMIT Procedimiento para registrar usuario---

----- Caso 1: Registrar un nuevo usuario con un correo que no existe en la tabla
EXEC sp_RegistrarUsuario 
    @Nombres = 'Juan',
    @Apellidos = 'Perez',
    @Correo = 'juan@example.com',
    @Clave = 'clave123',
    @Activo = 1,
    @Mensaje = @Mensaje OUTPUT,  -- Se declara antes de su uso
    @Resultado = @Resultado OUTPUT;
select * from USUARIO
-------------------------FIN PRUEBA--------------

GO
-----------BEGIN Procedimiento para editar usuario-------

create proc sp_EditarUsuario(
@IdUsuario int,
@Nombres varchar (100),
@Apellidos varchar(100),
@Correo varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
BEGIN
	Set @Resultado=0
	IF NOT EXISTS (Select *from USUARIO where Correo =  @Correo and IdUsuario !=@IdUsuario)
	BEGIN
		update top(1) USUARIO set
		Nombres =@Nombres,
		Apellidos = @Apellidos,
		Correo = @Correo,
		Activo =@Activo
		where IdUsuario = @IdUsuario
		Set @Resultado =1
	end
	else
	set @Mensaje ='El correo del usuario ya existe'
end
go
--------------------------------
DECLARE @Mensaje varchar(500)
DECLARE @Resultado bit

-- Ejemplo 1: Intentar editar un usuario con un correo que no existe para el ID de usuario proporcionado
EXEC sp_EditarUsuario 
    @IdUsuario = 3,  -- Supongamos que estamos editando el usuario con ID 1
    @Nombres = 'Juan',
    @Apellidos = 'Perez',
    @Correo = 'nuevo_correo@example.com',  -- Un nuevo correo que no existe para otro usuario
    @Activo = 1,
    @Mensaje = @Mensaje OUTPUT,
    @Resultado = @Resultado OUTPUT
	select * from USUARIO;
	GO

-----------COMMIT Procedimiento para registrar usuario-------

-----------BEGIN Procedimiento para registrar usuario-------

create proc sp_RegistrarCategoria(
@Descripcion varchar (100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output 
)
as
begin
	Set @Resultado=0
		IF NOT EXISTS (Select *from CATEGORIA where Descripcion =  @Descripcion )
		BEGIN
			insert into CATEGORIA(Descripcion,Activo) values
			(@Descripcion,@Activo)
			Set @Resultado = SCOPE_IDENTITY()
		end
		else
			set @Mensaje='La categoria ya existe'
	end
	go
-----------COMMIT Procedimiento para registrar categoria-------

-----------BEGIN Procedimiento para Editar categoria-------

create  proc sp_EditarCategoria(
	@IdCategoria int,
	@Descripcion VARCHAR(100),
	@Activo bit,
	@Mensaje varchar (500) output,
	@Resultado bit output
)
as
begin
	Set @Resultado=0
	if not Exists (Select *from Categoria where Descripcion=@Descripcion and IdCategoria != @IdCategoria)
	begin
		update top(1) Categoria set
		Descripcion = @Descripcion,
		Activo = @Activo
		where IdCategoria = @IdCategoria

		set @Resultado =1
	end
	else
		set @Mensaje = 'La categoria ya existe'
end
go
-----------COMMIT Procedimiento para editar categoria-------

-----------BEGIN Procedimiento para eliminar categoria-------


create proc sp_EliminarCategoria(
@IdCategoria int,
@Mensaje varchar (500) output,
@Resultado bit output

)
as
begin
	Set @Resultado=0
	if not Exists (Select *from  PRODUCTO p inner join CATEGORIA c on c.IdCategoria = p.IdCategoria where p.IdCategoria =@IdCategoria)
	begin
		delete top(1) from CATEGORIA where IdCategoria=@IdCategoria
		SET @Resultado=1
	end
	else
		set @Mensaje='La categoria se encuentra relacionada a un producto'
end
go
-----------COMMIT Procedimiento para eliminar categoria-------


-----------BEGIN Procedimiento para registrar Marca-------

create proc sp_RegistrarMarca(
@Descripcion varchar (100),
@Activo bit,
@Mensaje  varchar(500) output,
@Resultado	int output
)
as
begin
	Set @Resultado = 0
	if NOT EXISTS (Select * from Marca Where Descripcion=@Descripcion)
	begin
		insert into MARCA(Descripcion,Activo) values
		(@Descripcion,@Activo)

		Set @Resultado = SCOPE_IDENTITY()
	end
	else
		set @Mensaje ='La marca ya exiset'
end

go
drop sp_RegistarMarca
-----------COMMIT Procedimiento para registrar marca-------

-----------BEGIN Procedimiento para editar marca-------


create proc sp_EditarMarca(
@IdMarca int,
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar (500) output,
@Resultado bit output
)
as
begin
	set @Resultado=0
	if not Exists (Select * from MARCA where Descripcion=@Descripcion and IdMarca != @IdMarca)
	BEGIN
	update top (1) Marca set
	Descripcion = @Descripcion,
	Activo = @Activo
	where IdMarca = @IdMarca
	set @Resultado =1
endc
else
set @Mensaje='La marca ya existe'
end
go
-----------COMMIT Procedimiento para editar marca-------


-----------BEGIN Procedimiento para eliminar marca-------

create proc sp_EliminarMarca(
@IdMarca int,
@Mensaje varchar (500) output,
@Resultado bit output

)
as
begin
	Set @Resultado=0
	if not Exists (Select *from  PRODUCTO p inner join MARCA m on m.IdMarca = p.IdCategoria where p.IdMarca =@IdMarca)
	begin
		delete top(1) from MARCA where IdMarca=@IdMarca
		SET @Resultado=1
	end
	else
		set @Mensaje='La marca se encuentra relacionada a un producto'
end
go

-----------COMMIT Procedimiento para eliminar marca-------



-----------BEGIN Procedimiento para REGISTRAR producto-------

drop proc sp_RegistarProducto
go
create proc sp_RegistrarProducto(
@Nombre varchar(100),
@Descripcion varchar(100),
@IdMarca varchar(100),
@IdCategoria varchar(100),
@Precio decimal (10,2),
@Stock int,
@Activo bit,
@Mensaje varchar (500) output,
@Resultado int output
)
as
begin
	Set @Resultado = 0
	if not exists (select * from PRODUCTO where Nombre = @Nombre)
	begin
		insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,Activo) values
		(@Nombre,@Descripcion,@IdMarca,@IdCategoria,@Precio,@Stock,@Activo)
		SET @Resultado = SCOPE_IDENTITY()
	end
	else
		set @Mensaje= 'El producto ya existe'
end
go
-----------COMMIT Procedimiento para REGISTRAR producto-------


-----------BEGIN Procedimiento para EDITAR producto-------

create proc sp_EditarProducto(
@IdProducto int,
@Nombre varchar(100),
@Descripcion varchar(100),
@IdMarca varchar(100),
@IdCategoria varchar(100),
@Precio decimal (10,2),
@Stock int,
@Activo bit,
@Mensaje varchar (500) output,
@Resultado bit output
)
as
begin
	set @Resultado = 0
	if not exists (select * from PRODUCTO where Nombre= @Nombre and IdProducto != @IdProducto)
	BEGIN
		update PRODUCTO set
		Nombre = @Nombre,
		Descripcion = @Descripcion,
		IdMarca = @IdMarca,
		IdCategoria = @IdCategoria,
		Precio = @Precio,
		Stock = @Stock,
		Activo = @Activo
		where IdProducto = @IdProducto

		SET @Resultado = 1
	end
	else
		set @Mensaje = 'El producto ya existe'
end

go
-----------COMMIT Procedimiento para EDITAR producto-------


-----------BEGIN Procedimiento para ELIMINAR producto-------

create proc sp_EliminarProducto(
@IdProducto int,
@Mensaje varchar (500) output,
@Resultado bit output

)
as
begin
	Set @Resultado=0
	if not Exists (Select *from DETALLE_VENTA dv inner join PRODUCTO p on p.IdProducto = dv.IdProducto where p.IdProducto =@IdProducto)
	begin
		delete top(1) from PRODUCTO where IdProducto=@IdProducto
		SET @Resultado=1
	end
	else
		set @Mensaje='El producto se encuentra relacionada a una venta'
end
go
select * from PRODUCTO
go
-----------COMMIT Procedimiento para EDITAR producto-------



-----------BEGIN Procedimiento para SELECCIONAR DATOS EN FRONT-END-------

create proc sp_ReporteDashboard
as
begin
select
(select count(*)from CLIENTE) [TotalCliente],
(select isnull(sum(cantidad),0)from DETALLE_VENTA) [TotalVenta],
(select count(*)from PRODUCTO) [TotalProducto]
end

exec sp_ReporteDashboard
go
exec sp_ReporteDashboard
-----------COMMIT Procedimiento para SELECCIONAR DATOS EN FRONT-END-------

-----------BEGIN Procedimiento para DAR REPORTE DE VENTAS DE productos-------

create proc sp_ReporteVentas(
@fechainicio varchar (10),
@fechafin varchar(10),
@idtransaccion varchar (50)
)
as
begin
set dateformat dmy;

select CONVERT(char(10),v.FechaVenta,103)[FechaVenta], CONCAT (c.Nombre, ' ',c.Apellidos)[Cliente],
p.Nombre[Producto],p.Precio ,dv.Cantidad,dv.Total, v.IdTransaccion
from DETALLE_VENTA dv 
inner join PRODUCTO p on p.IdProducto = dv.IdProducto
inner join VENTA v  on v.IdVenta = dv.IdVenta
inner join CLIENTE c on c.IdCliente = v.IdCliente
where CONVERT(date, v.FechaVenta) between @fechainicio and @fechafin
and v.IdTransaccion = iif(@idtransaccion= '',v.IdTransaccion,@idtransaccion)
end

go
exec sp_ReporteVentas
-----------COMMIT Procedimiento para DAR REPORTE DE VENTAS DE productos-------

select * from CLIENTE
select * from PRODUCTO
select * from CATEGORIA
SELECT * FROM MARCA

create proc sp_ExisteCarrito(
@IdCliente int,
@IdProducto int,
@Resultado bit output
)
as
begin
	if exists(select *from carrito where idcliente =@IdCliente and IdProducto =@IdProducto)
			set @Resultado=1
		else
			set @Resultado=0
end



create proc sp_OperacionCarrito(
@IdCliente int,
@IdProducto int,
@Sumar bit,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	set @Resultado = 1
	set @Mensaje = ''

	declare @existecarrito bit =iif(exists(select *from carrito where idcliente = @IdCliente and idproducto =@IdProducto),1,0)
	declare @stockproducto int = (select stock from PRODUCTO where IdProducto =@IdProducto)
	
	BEGIN TRY
		BEGIN TRANSACTION OPERACION

		if(@Sumar=1)
		BEGIN
			if(@stockproducto>0)
			begin
				if(@existecarrito =1)
					update CARRITO set Cantidad =Cantidad + 1 where idcliente = @IdCliente and idproducto =@IdProducto
				else
					insert into CARRITO(IdCliente,IdProducto,Cantidad)values(@IdCliente,@IdProducto,1)
				update PRODUCTO set Stock =Stock - 1 where IdProducto=@IdProducto
			end
			else
			begin
				set	@Resultado =0
				set	@Mensaje = 'El producto no cuenta con stock'
			end

		end
		else
		begin
			update CARRITO set Cantidad =Cantidad - 1 where idCliente =@IdCliente and idproducto = @IdProducto
			update PRODUCTO set Stock = Stock + 1 where IdProducto =@IdProducto
		end
		COMMIT TRANSACTION OPERACION
	END TRY

	BEGIN CATCH
		set @Resultado = 0
		set @Mensaje =ERROR_MESSAGE()
		ROLLBACK TRANSACTION OPERACION
	END CATCH
end
go

select count (*) from CARRITO where idcliente =1
	select * from CLIENTE
	select * from USUARIO
drop RegistrarCliente
CREATE PROCEDURE sp_RegistrarCliente
    @Nombres VARCHAR(100),
    @Apellidos VARCHAR(100),
    @Correo VARCHAR(100),
    @Clave VARCHAR(100),
    @Mensaje VARCHAR(500) OUTPUT,
    @Resultado INT OUTPUT
AS

BEGIN
    SET @Resultado = 0;
    IF NOT EXISTS (SELECT * FROM CLIENTE WHERE Correo = @Correo)
    BEGIN
        INSERT INTO CLIENTE (Nombre, Apellidos, Correo, Clave, Reestablecer)
        VALUES (@Nombres, @Apellidos, @Correo, @Clave, 1); -- Establecer Reestablecer en 1 automáticamente

        SET @Resultado = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        SET @Mensaje = 'El correo del usuario ya existe';
    END;
END;
GO
DELETE FROM Cliente
WHERE idcLIENTE IN (7, 9, 10,11,12,13,14,15,16,17,18,19,20,21);
----------
DELETE FROM Carrito
WHERE idCarrito IN (1, 2, 3,4,5,6,7,8);
select * from Cliente 
select * from CARRITO
create proc sp_RegistrarCliente(
@Nombres varchar(100),
@Apellidos varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin
	Set @Resultado=0
		IF NOT EXISTS (Select *from CLIENTE WHERE Correo = @Correo)
		begin 
			insert into CLIENTE(Nombre,Apellidos,Correo,Clave,Reestablecer)values(@Nombres,@Apellidos,@Correo,@Clave,0)

			Set @Resultado = SCOPE_IDENTITY()
		end
		else
			set @Mensaje = 'El correo del usuario ya existe'
end	


GO


CREATE PROCEDURE ValidarUsuario
(
  @Correo VARCHAR(100),
  @Clave VARCHAR(150),
  @IdCliente INT OUTPUT
)
AS
BEGIN
  -- Validar si el usuario existe
  SELECT @IdCliente = IdCliente
  FROM CLIENTE
  WHERE Correo = @Correo AND Clave = @Clave;

  -- Si el usuario no existe, devolver -1
  IF @IdCliente IS NULL
  BEGIN
    SET @IdCliente = -1;
    RETURN;
  END

  -- Si el usuario existe, devolver su ID
  RETURN;
END


DECLARE @IdCliente INT;

EXEC ValidarUsuario 'juan@example.com', 'clave123', @IdCliente OUTPUT;

IF @IdCliente = -1
BEGIN
  PRINT 'La clave no coincide';
END
ELSE
BEGIN	
  PRINT 'El usuario existe y la clave coincide. El ID del usuario es ' + CAST(@IdCliente AS VARCHAR);
END
select * from CLIENTE



select * from Cliente



create function fn_obtenerCarritoCliente(
@idcliente int
)
returns table
as
return(
	select p.IdProducto,m.Descripcion[DesMarca],p.Nombre,p.Precio,c.Cantidad,p.RutaImagen,p.NombreImagen
	from CARRITO c
	inner join PRODUCTO p on p.IdProducto=c.IdProducto
	inner join MARCA m on m.IdMarca=p.IdMarca
	where c.IdCliente = @idcliente
)
select * from CLIENTE
select * from carrito 
select * from fn_obtenerCarritoCliente(22)



create proc sp_EliminarCarrito(
@IdCliente int,
@IdProducto int,
@Resultado bit output
)
as
begin

	set @Resultado =1
	declare @cantidadproducto int =(select Cantidad from CARRITO where IdCliente =@IdCliente and IdProducto= @IdProducto)
	BEGIN TRY
		BEGIN TRANSACTION OPERACION

		update PRODUCTO set Stock = Stock + @cantidadproducto where IdProducto = @IdProducto
		delete top (1) from CARRITO	where IdCliente =@IdCliente and IdProducto = @IdProducto

		Commit TRANSACTION OPERACION
	END TRY
	BEGIN CATCH
		set @Resultado=0
		ROLLBACK TRANSACTION OPERACION
	END CATCH
end