<!DOCTYPE html>
<html>
<head>
<title>Login Screen</title>
<style>
	body {
		background-color: #ffe6f3; 
		color: #5D5348; 
		font-family: Arial, sans-serif;
	}

	h3 {
		color: #ff67ca; 
		font-size: 1.1em; 
	}


	input[type=submit] {
        background-color: #f991e1;
  		border: none;
		color: white;
		padding: 8px 12px;
		border-radius: 8px;
		margin: 2px 2px;
    }
</style>
</head>
<body>

<%@ include file="header.jsp" %>

<div style="margin:0 auto;text-align:center;display:inline">

<h3>Please Login to System</h3>

<%
// Print prior error login message if present
if (session.getAttribute("loginMessage") != null)
	out.println("<p>"+session.getAttribute("loginMessage").toString()+"</p>");
%>

<br>
<form name="MyForm" method=post action="validateLogin.jsp">
<table style="display:inline">
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="3">Username:</font></div></td>
	<td><input type="text" name="username"  size=15 maxlength=10></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="3">Password:</font></div></td>
	<td><input type="password" name="password" size=15 maxlength="10"></td>
</tr>
</table>
<br/>
<input class="submit" type="submit" name="Submit2" value="Log In">
</form>

</div>

</body>
</html>

