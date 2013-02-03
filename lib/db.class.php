<?php
/*
Simple DB wrapper class

Polovko Mikhail
*/
class db 
{
	var $mysqli;
	
	function __construct()
	{
		$DB_NAME = 'trinetix';
		$DB_HOST = 'localhost';
		$DB_USER = 'root';
		$DB_PASS = '';
		
		$this->mysqli = new mysqli($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
		
		if (mysqli_connect_errno()) {
			printf("Connect failed: %s\n", mysqli_connect_error());
			exit();
		}
	}
	
	function __destruct()
	{
		mysqli_close($this->mysqli);
	}	
	
	function raw_query($query)
	{
		return $this->mysqli->query($query) or die($this->mysqli->error.__LINE__);
	}
	
	function get_all($query)
	{
		$return = array();
		$result = $this->mysqli->query($query) or die($this->mysqli->error.__LINE__);
		if($result->num_rows > 0) {
			while($row = $result->fetch_assoc()) 
				array_push($return,$row);
			return $return; 	
		}
		else 
			return false;	
	}
	
	function get_one($query)
	{
		$return = array();
		$result = $this->mysqli->query($query) or die($this->mysqli->error.__LINE__);
		if($result->num_rows > 0) {
			return $result->fetch_assoc(); 	
		}
		else 
			return false;	
	}	
	
	
	function insert($table, $params)
	{
		$query = 'INSERT INTO '.$table.' (';
		
		foreach(array_keys($params) as $column){
			$query .= "".$column.", ";
		}
		$query = substr($query,0,-2);
		$query .= ') VALUES (';

		foreach(array_values($params) as $value){
			$query .= "'".$value."', ";
		}
		$query = substr($query,0,-2);
		$query .= ') ';
		
		return $this->mysqli->query($query) or die($this->mysqli->error.__LINE__);
	}
	
	function update($table, $params, $where=false)
	{
		$query = 'UPDATE '.$table.' SET ';
		foreach($params as $key => $value)
		{
			$query .= $key."='".$value."', ";
		}
		$query = substr($query,0,-2);
		$query .= ' ';
		
		if ($where && is_array($where))
		{
			$query .= 'WHERE ';
			foreach($where as $key => $value)
			{
				$query .= $key."='".$value."' AND ";
			}
			$query = substr($query,0,-5);
			$query .= ' ';
		}

		return $this->mysqli->query($query) or die($this->mysqli->error.__LINE__);
	}
	
}
