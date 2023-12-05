<!DOCTYPE html>
<html>
<head>
<title> Grocery CheckOut Line</title>
<style> 
	body {
		background-color: #ffe6f3; 
		color: #5D5348; 
		font-family: Arial, sans-serif;
	}

	h3 {
		color: #f991e1; 
		font-size: 1.3em; 
		text-align: left; 
	}

    input[type=text] {
        width: 25%;
        padding: 10px 17px;
        margin: 8px 0;
        box-sizing: border-box;
    }

	input[type=submit] {
        background-color: #f991e1;
  		border: none;
		color: white;
		padding: 10px 25px;
		border-radius: 8px;
		margin: 2px 2px;
    }

	input[type=reset] {
        background-color: #f991e1;
  		border: none;
		color: white;
		padding: 10px 25px;
		border-radius: 8px;
		margin: 2px 2px;
    }

	</style>
</head>
<body>

<h3> Enter your customer id and password to complete the transaction: </h3>

<form method="get" action="order.jsp">
<label for="fname">Customer Id:</label><br>
<input type="text" name="customerId" size="50"> <br>
<label for="fname">Password:</label><br>
<input type="text" name="customerPassword" size="50"> <br>
<input type="submit" value="Submit"> 	<input type="reset" value="Reset">
</form>


</body>
</html>

