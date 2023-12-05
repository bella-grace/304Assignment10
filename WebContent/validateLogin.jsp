<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);

	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";	// Make connection	
	String uid = "sa";
	String pw = "304#sa#pw";

	try {
		authenticatedUser = validateLogin(out,request,session);
	} catch(IOException e) {
		System.err.println(e);
	}

	if(authenticatedUser != null)
		response.sendRedirect("index.jsp");		// Successful login
	else
		response.sendRedirect("login.jsp");		// Failed login - redirect back to login page with a message 
%>


<%!
	String validateLogin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;

		if(username == null || password == null || username.isEmpty() || password.isEmpty()) {
			return null;
		}

		Connection con = null;														//Create variables for connection
		PreparedStatement pstmt = null;
		ResultSet rst = null;

		try {
			con = DriverManager.getConnection(url, uid, pw);
			Statement stmt = con.createStatement();
			
			// Check if userId and password match some customer account. If so, set retStr to be the username.
			String SQL = "SELECT userId, customerId FROM customer WHERE userId = ? AND password = ?";
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, username);
			pstmt.setString(2, password);

			rst = pstmt.executeQuery();

			if(!rst.next()) {
				throw new NullPointerException();
			} 

			retStr = username; 
			session.setAttribute("customerId", rst.getString("customerId"));
		} 
		catch (SQLException ex) {
			out.println(ex);
		} catch (NullPointerException ex) {
			out.println("<h2>Incorrect username or password</h2>");
		} finally {
			closeConnection();
		}	
		
		if(retStr != null)
		{	session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser", username);
		}
		else {
			session.setAttribute("loginMessage","Could not connect to the system using that username/password.");
		}
		return retStr;
	}
%>

