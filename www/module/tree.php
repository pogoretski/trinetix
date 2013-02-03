<?php

// If we have an AJAX POST request:
if ($_POST)	
{
	$action = $_POST['func'];

	//1. Отдать child'ы следующего уровня определенного parent'a
	if ($action =='getChild')
	{
		$parentId = $_POST['parentId'];
		
		//Getting second level of node
		$sql = "SELECT node.id, node.name, (COUNT(parent.name) - (sub_tree.depth + 1)) AS depth, (node.rgt-node.lft-1) div 2 as childs
				FROM category AS node,
				        category AS parent,
				        category AS sub_parent,
				        (
				                SELECT node.name, (COUNT(parent.name) - 1) AS depth
				                FROM category AS node,
				                        category AS parent
				                WHERE node.lft BETWEEN parent.lft AND parent.rgt
				                        AND node.id = '".$parentId."'
				                GROUP BY node.name
				                ORDER BY node.lft
				        )AS sub_tree
				WHERE node.lft BETWEEN parent.lft AND parent.rgt
				        AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
				        AND sub_parent.name = sub_tree.name
				GROUP BY node.name
				HAVING depth = 1
				ORDER BY node.lft
				
				";
		$children = $db->get_all($sql);
		echo json_encode(array('children' => $children, 'count'=>count($children))); 
		die;
	}
	
	//2. Отдать все чайлды определенного parent'а
	if ($action =='getFullPath')
	{
		//Getting full node 'till the leaves
		$parentId = $_POST['parentId'];
		$sql = "SELECT  node.id, node.name, (COUNT(parent.name) - (sub_tree.depth + 1)) AS depth, (node.rgt-node.lft-1) div 2 as childs
		FROM category AS node,
		    category AS parent,
		    category AS sub_parent,
		    (
		            SELECT node.name, (COUNT(parent.name) - 1) AS depth
		            FROM category AS node,
		            category AS parent
		            WHERE node.lft BETWEEN parent.lft AND parent.rgt
		            AND node.id = '".$parentId."'
		            GROUP BY node.name
		            ORDER BY node.lft
		    )AS sub_tree
		WHERE node.lft BETWEEN parent.lft AND parent.rgt
		    AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
		    AND sub_parent.name = sub_tree.name
		GROUP BY node.name
		HAVING depth > 0
		ORDER BY node.lft;
		";
		
		$children = $db->get_all($sql);
		
		$max_depth = 0;
		foreach($children as $child){
			if ($max_depth < $child['depth'])
				$max_depth = $child['depth'];
		}
		echo json_encode(array('children' => $children, 'count'=>count($children), 'max_depth'=>$max_depth)); 
		die;
	}
	die;
}

//Top nodes of the tree for main page
$sql = 'SELECT node.id, node.name, (COUNT(parent.name) - 1) AS depth, (node.rgt-node.lft-1) div 2 as childs
FROM category AS node,
        category AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt
GROUP BY node.name
HAVING depth = 0
ORDER BY node.lft;';

$start_tree = $db->get_all($sql);

