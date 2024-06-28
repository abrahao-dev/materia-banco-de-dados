use EasyRentCar

-- exercício 1

CREATE TABLE Cliente (
    CodigoCliente INT PRIMARY KEY,
    Nome VARCHAR(100),
    CPF VARCHAR(14) UNIQUE,
    Sexo CHAR(1),
    DataNascimento DATE,
    CidadeResidencia VARCHAR(100),
    Email VARCHAR(100),
    Senha VARCHAR(50)
);

CREATE TABLE Marca (
	CodigoMarca INT PRIMARY KEY,
	Nome VARCHAR(100)
);

CREATE TABLE Modelo (
	CodigoModelo INT PRIMARY KEY,
	CodigoMarca INT,
	Nome VARCHAR(100)
);

CREATE TABLE Agencia (
	CodigoAgencia INT PRIMARY KEY,
	Nome VARCHAR(100),
	Cidade VARCHAR(100),
	Estado VARCHAR(100)
);

CREATE TABLE AgenciaModeloDisponivel (
    CodigoAgenciaModeloDisponivel INT PRIMARY KEY,
    CodigoAgencia INT,
    CodigoModelo INT,
    Placa VARCHAR(7),
    DataHoraAgencia DATETIME,
    CONSTRAINT FK_AgenciaModeloDisponivel_Agencia FOREIGN KEY (CodigoAgencia) REFERENCES Agencia(CodigoAgencia),
    CONSTRAINT FK_AgenciaModeloDisponivel_Modelo FOREIGN KEY (CodigoModelo) REFERENCES Modelo(CodigoModelo)
);

CREATE TABLE Locacao (
    CodigoLocacao INT PRIMARY KEY,
    DataHoraPedido DATETIME,
    CodigoCliente INT,
    DataInicioLocacao DATE,
    CodigoAgenciaModeloDisponivelRetirada INT,
    QtdDiasAluguel INT,
    CodigoAgenciaDevolucao INT,
    DataDevolucaoEfetiva DATE
);

ALTER TABLE Locacao
ADD CONSTRAINT FK_Locacao_Cliente FOREIGN KEY (CodigoCliente)
REFERENCES Cliente(CodigoCliente);

ALTER TABLE Locacao
ADD CONSTRAINT FK_Locacao_AgenciaModeloDisponivel FOREIGN KEY (CodigoAgenciaModeloDisponivelRetirada)
REFERENCES AgenciaModeloDisponivel(CodigoAgenciaModeloDisponivel);

ALTER TABLE Locacao
ADD CONSTRAINT FK_Locacao_Agencia FOREIGN KEY (CodigoAgenciaDevolucao)
REFERENCES Agencia(CodigoAgencia);

-- exercício 2
CREATE PROCEDURE STPAgenciaInserir
    @Nome VARCHAR(100),
    @Cidade VARCHAR(100),
    @Estado VARCHAR(100)
AS
BEGIN
    INSERT INTO Agencia (Nome, Cidade, Estado)
    VALUES (@Nome, @Cidade, @Estado);
END;

-- exercício 3

-- Inserindo a primeira agência
EXEC STPAgenciaInserir 'Agência Central', 'São Paulo', 'SP';

-- Inserindo a segunda agência
EXEC STPAgenciaInserir 'Agência Norte', 'Manaus', 'AM';

-- Inserindo a terceira agência
EXEC STPAgenciaInserir 'Agência Sul', 'Porto Alegre', 'RS';

-- exercício 4

CREATE PROCEDURE STPClienteInserir
    @Nome VARCHAR(100),
    @CPF VARCHAR(14),
    @Sexo CHAR(1),
    @DataNascimento DATE,
    @CidadeResidencia VARCHAR(100),
    @Email VARCHAR(100),
    @Senha VARCHAR(50)
AS
BEGIN
    INSERT INTO Cliente (Nome, CPF, Sexo, DataNascimento, CidadeResidencia, Email, Senha)
    VALUES (@Nome, @CPF, @Sexo, @DataNascimento, @CidadeResidencia, @Email, @Senha);
END;

-- exercício 5

-- Inserindo o primeiro cliente
EXEC STPClienteInserir 'João Silva', '123.456.789-00', 'M', '1985-01-01', 'São Paulo', 'joao.silva@example.com', 'senha123';

-- Inserindo o segundo cliente
EXEC STPClienteInserir 'Maria Oliveira', '987.654.321-00', 'F', '1990-05-15', 'Rio de Janeiro', 'maria.oliveira@example.com', 'senha456';

-- Inserindo o terceiro cliente (menor de 18 anos)
EXEC STPClienteInserir 'Pedro Santos', '111.222.333-44', 'M', '2010-03-20', 'Belo Horizonte', 'pedro.santos@example.com', 'senha789';

-- exercício 6

CREATE PROCEDURE STPAgenciaModeloDisponivelInserir
    @CodigoAgencia INT,
    @CodigoModelo INT,
    @Placa VARCHAR(7),
    @DataHoraAgencia DATETIME
AS
BEGIN
    INSERT INTO AgenciaModeloDisponivel (CodigoAgencia, CodigoModelo, Placa, DataHoraAgencia)
    VALUES (@CodigoAgencia, @CodigoModelo, @Placa, @DataHoraAgencia);
END;

-- exercício 7

-- Inserir modelos na primeira agência
EXEC STPAgenciaModeloDisponivelInserir 1, 1, 'ABC1234', '2024-05-14 10:00:00';
EXEC STPAgenciaModeloDisponivelInserir 1, 2, 'DEF5678', '2024-05-14 11:00:00';
EXEC STPAgenciaModeloDisponivelInserir 1, 3, 'GHI9012', '2024-05-14 12:00:00';

-- Inserir modelos na segunda agência
EXEC STPAgenciaModeloDisponivelInserir 2, 4, 'JKL3456', '2024-05-14 13:00:00';
EXEC STPAgenciaModeloDisponivelInserir 2, 5, 'MNO7890', '2024-05-14 14:00:00';
EXEC STPAgenciaModeloDisponivelInserir 2, 6, 'PQR1234', '2024-05-14 15:00:00';

-- Inserir modelos na terceira agência
EXEC STPAgenciaModeloDisponivelInserir 3, 7, 'STU5678', '2024-05-14 16:00:00';
EXEC STPAgenciaModeloDisponivelInserir 3, 8, 'VWX9012', '2024-05-14 17:00:00';
EXEC STPAgenciaModeloDisponivelInserir 3, 9, 'YZA3456', '2024-05-14 18:00:00';

-- exercício 8

CREATE PROCEDURE STPLocacaoInserir
    @CodigoLocacao INT,
    @DataHoraPedido DATETIME,
    @CodigoCliente INT,
    @DataInicioLocacao DATE,
    @CodigoAgenciaModeloDisponivelRetirada INT,
    @QtdDiasAluguel INT,
    @CodigoAgenciaDevolucao INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica se o cliente tem 18 anos ou mais
    IF DATEDIFF(YEAR, (SELECT DataNascimento FROM Cliente WHERE CodigoCliente = @CodigoCliente), GETDATE()) >= 18
    BEGIN
        -- Verifica se a quantidade de dias de aluguel é igual ou superior a 10
        IF @QtdDiasAluguel >= 10
        BEGIN
            -- Insere o aluguel na tabela Locacao com a data de devolução efetiva como nulo
            INSERT INTO Locacao (CodigoLocacao, DataHoraPedido, CodigoCliente, DataInicioLocacao, CodigoAgenciaModeloDisponivelRetirada, QtdDiasAluguel, CodigoAgenciaDevolucao, DataDevolucaoEfetiva)
            VALUES (@CodigoLocacao, @DataHoraPedido, @CodigoCliente, @DataInicioLocacao, @CodigoAgenciaModeloDisponivelRetirada, @QtdDiasAluguel, @CodigoAgenciaDevolucao, NULL);
        END
        ELSE
        BEGIN
            PRINT 'O aluguel deve ter 10 ou mais dias.';
        END
    END
    ELSE
    BEGIN
        PRINT 'O cliente deve ter 18 anos ou mais para realizar um aluguel.';
    END
END;

-- exercício 9

CREATE PROCEDURE STPLocacaoBaixa
    @CodigoLocacao INT,
    @DataDevolucaoEfetiva DATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica se a locação existe e se a data de devolução efetiva é nula
    IF EXISTS (SELECT * FROM Locacao WHERE CodigoLocacao = @CodigoLocacao AND DataDevolucaoEfetiva IS NULL)
    BEGIN
        -- Atualiza a data de devolução efetiva na tabela Locacao
        UPDATE Locacao
        SET DataDevolucaoEfetiva = @DataDevolucaoEfetiva
        WHERE CodigoLocacao = @CodigoLocacao;

        -- Realiza a inserção na tabela AgenciaModeloDisponivel
        -- Aqui aproveitamos a stored procedure já existente STPAgenciaModeloDisponivelInserir
        -- Se a atualização for bem-sucedida, inserimos na tabela AgenciaModeloDisponivel
        EXEC STPAgenciaModeloDisponivelInserir 
            (SELECT CodigoAgenciaModeloDisponivelRetirada FROM Locacao WHERE CodigoLocacao = @CodigoLocacao),
            @DataDevolucaoEfetiva;

        PRINT 'Baixa realizada com sucesso.';
    END
    ELSE
    BEGIN
        PRINT 'Não foi possível realizar a baixa. Locação não encontrada ou já foi baixada anteriormente.';
    END
END;

EXEC STPAgenciaModeloDisponivelInserir 
    (SELECT CodigoAgenciaModeloDisponivelRetirada FROM Locacao WHERE CodigoLocacao = @CodigoLocacao),
    @DataDevolucaoEfetiva;
