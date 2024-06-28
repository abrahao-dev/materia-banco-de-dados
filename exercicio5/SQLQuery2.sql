use BD_AulaJoin

SELECT e.IDEstado, COUNT(c.IDCidade) AS Numero_de_Cidades
FROM Estado e
INNER JOIN Cidade c ON e.IDEstado = c.IDEstado
GROUP BY e.NomeEstado;

SELECT e.NomeEstado, COUNT(f.IDFuncionario) AS Numero_de_Funcionarios
FROM Estado e
INNER JOIN Funcionario f ON e.IDEstado = f.IDEstado
GROUP BY e.NomeEstado;

SELECT Nome
FROM Funcionario
WHERE Salario = (SELECT MAX(Salario) FROM Funcionario);

SELECT AVG(Salario) AS Media_Salarial
FROM Funcionario;