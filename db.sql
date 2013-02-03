 /* - выборки ноды и всех чайлдов; */ 
SELECT node.name
FROM category AS node,
        category AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt
        AND parent.id = 4
ORDER BY node.lft;
//где parent.id - это id ноды

 /* - добавления ноды  */
LOCK TABLE category WRITE;

SELECT @myRight := rgt FROM category
WHERE id = 5;

UPDATE category SET rgt = rgt + 2 WHERE rgt > @myRight;
UPDATE category SET lft = lft + 2 WHERE lft > @myRight;

INSERT INTO category(name, lft, rgt) VALUES('Arm', @myRight + 1, @myRight + 2);

UNLOCK TABLES;
//где id - это id ноды, после которой нужно вставить ноду

 /* - добавления чайлда в ноду; */
LOCK TABLE category WRITE;

SELECT @myLeft := lft FROM category

WHERE id = 11;

UPDATE category SET rgt = rgt + 2 WHERE rgt > @myLeft;
UPDATE category SET lft = lft + 2 WHERE lft > @myLeft;

INSERT INTO category(name, lft, rgt) VALUES('i7 extreme', @myLeft + 1, @myLeft + 2);

UNLOCK TABLES;
//где id - это id ноды, в которую нужно вставить чайлда

 /* - удаления ноды и всех чайлдов; */
 LOCK TABLE category WRITE;

SELECT @myLeft := lft, @myRight := rgt, @myWidth := rgt - lft + 1
FROM category
WHERE id = 11;

DELETE FROM category WHERE lft BETWEEN @myLeft AND @myRight;

UPDATE category SET rgt = rgt - @myWidth WHERE rgt > @myRight;
UPDATE category SET lft = lft - @myWidth WHERE lft > @myRight;

UNLOCK TABLES;
//где id - это id ноды, которую нужно удалить