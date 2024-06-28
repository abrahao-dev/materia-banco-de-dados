use master

create database aula1

CREATE TABLE Profissional 
( 
 nome INT,  
 id_controle INT PRIMARY KEY,  
 endereço INT,  
 nascimento INT,  
 profissão INT,  
); 

CREATE TABLE Contrato 
( 
 inicio INT,  
 termino INT,  
 valor_hora INT,  
 cpf_empresa_cliente INT,  
 id_controleDoProfissional INT,  
 id_contrato INT PRIMARY KEY,  
); 

CREATE TABLE EmpresaCliente 
( 
 cpf INT PRIMARY KEY,  
 nome INT,  
 endereço INT,  
); 

CREATE TABLE Rel 
( 
 id_controle INT PRIMARY KEY,  
 cpf_empresa_cliente INT,  
); 

CREATE TABLE Rel1 
( 
 cpf INT PRIMARY KEY,  
 cpf_empresa_cliente INT,  
); 

ALTER TABLE Contrato ADD FOREIGN KEY(cpf_empresa_cliente) REFERENCES undefined (cpf_empresa_cliente)
ALTER TABLE Contrato ADD FOREIGN KEY(id_controleDoProfissional) REFERENCES undefined (id_controleDoProfissional)
ALTER TABLE Rel ADD FOREIGN KEY(id_controle) REFERENCES Profissional (id_controle)
ALTER TABLE Rel ADD FOREIGN KEY(cpf_empresa_cliente) REFERENCES Contrato (cpf_empresa_cliente)
ALTER TABLE Rel1 ADD FOREIGN KEY(cpf) REFERENCES EmpresaCliente (cpf)
ALTER TABLE Rel1 ADD FOREIGN KEY(cpf_empresa_cliente) REFERENCES Contrato (cpf_empresa_cliente)