insert into USUARIO(Nombres,Apellidos,Correo,Clave) values ('test nombre','test apellido','test@example.com','ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae')
insert into USUARIO(Nombres,Apellidos,Correo,Clave) values ('1','1','1@1','1')
INSERT INTO CLIENTE (Nombre, Apellidos, Correo, Clave)
VALUES ('Juan', 'P�rez', 'juan@example.com', 'clave123');
 go
 select * from USUARIO
  select * from CATEGORIA

 insert into CATEGORIA(Descripcion) values 
 ('Tecnologia'),
 ('Muebles'),
 ('Dormitorio'),
  ('Deportes')


go	
sELECT * FROM MARCA
  insert into MARCA(Descripcion) values
('SONYTE'),
('HPTE'),
('LGTE'),
('HYUNDAITE'),
('CANONTE'),
('ROBERTA ALLENTE')


go

Select * FROM DEPARTAMENTO
insert into DEPARTAMENTO(IdDepartamento,Descripcion)
values 
('01','Arequipa'),
('02','Ica'),
('03','Lima')


go
Select * from PROVINCIA
insert into PROVINCIA(IdProvincia,Descripcion,IdDepartamento)
values
('0101','Arequipa','01'),
('0102','Caman�','01'),

--ICA - PROVINCIAS
('0201', 'Ica ', '02'),
('0202', 'Chincha ', '02'),

--LIMA - PROVINCIAS
('0301', 'Lima ', '03'),
('0302', 'Barranca ', '03')


go
Select * from DISTRITO
insert into DISTRITO(IdDistrito,Descripcion,IdProvincia,IdDepartamento) values 
('010101','Nieva','0101','01'),
('010102', 'El Cenepa', '0101', '01'),

('010201', 'Caman�', '0102', '01'),
('010202', 'Jos� Mar�a Quimper', '0102', '01'),

--ICA - DISTRITO
('020101', 'Ica', '0201', '02'),
('020102', 'La Tingui�a', '0201', '02'),
('020201', 'Chincha Alta', '0202', '02'),
('020202', 'Alto Laran', '0202', '02'),


--LIMA - DISTRITO
('030101', 'Lima', '0301', '03'),
('030102', 'Anc�n', '0301', '03'),
('030201', 'Barranca', '0302', '03'),
('030202', 'Paramonga', '0302', '03')
