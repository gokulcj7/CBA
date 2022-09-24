<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="style.css" rel="stylesheet" type="text/css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat&family=Teko:wght@500&display=swap" rel="stylesheet">
	 <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

	<!-- Optional theme -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">
	<script src="script.js"></script>
	<title>Update</title>

</head>

<body>
	<nav class="navbar navbar-light" style="background-color: #e3f2fd;">
	<ul class="nav navbar-nav navbar-right">
		<li class="dropdown">
          <a class="dropdown-toggle" data-toggle="dropdown" href="#"><span class="glyphicon glyphicon-user"></span><%= request.getRemoteUser()%> <span class="caret"></span></a>
          <ul class="dropdown-menu">
            <li><a href="LogoutServlet">Logout</a></li>
          </ul>
        </li>
	</ul>
	 <div class="title">
        <a class="navbar-brand mx-auto" href="#">Hospital Management System</a>
	 </div>
	</nav>

    <%@page import="java.util.*"%>
    <%@page import="java.sql.*"%>

    <%

    if(HttpServlet.getMethod()=="POST"){
        try
		{
			Connection con=DriverManager.getConnection("jdbc:mysql://localhost/covid","root","Gokul@2001");
			String query1="update hospital_information set normal_bed =? where hospital_id=?";
			String query2="update hospital_information set oxygen_bed =? where hospital_id=?";
			String query3="update hospital_information set icu_bed =? where hospital_id=?";
			String query4="update hospital_information set Hospital_Name =? where hospital_id=?";
			
			
		
			PreparedStatement st1 = con.prepareStatement(query1);
			PreparedStatement st2 = con.prepareStatement(query2);
			PreparedStatement st3 = con.prepareStatement(query3);
			PreparedStatement st4 = con.prepareStatement(query4);
			
			int id=Integer.parseInt(request.getParameter("id").trim());
			
			st1.setInt(1,Integer.parseInt(request.getParameter("nbed").trim()));
			st1.setInt(2,id);
			
			
			st2.setInt(1,Integer.parseInt(request.getParameter("obed").trim()));
			st2.setInt(2,id);
			
			st3.setInt(1,Integer.parseInt(request.getParameter("ibed").trim()));
			st3.setInt(2,id);
			
			st4.setString(1,request.getParameter("name").trim());
			st4.setInt(2,id);
			
			
			int n1=st1.executeUpdate();
			int n2=st2.executeUpdate();
			int n3=st3.executeUpdate();
			int n4=st4.executeUpdate();

        }
        catch(Exception e)
		{
			e.printStackTrace();
		}
        try{
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost/covid","root","Gokul@2001");
            Statement st=con.createStatement();
            String sql="select hospitals.hospital_id,hospital_information.Hospital_Name,hospitals.location,hospital_information.normal_bed,hospital_information.oxygen_bed,hospital_information.icu_bed FROM hospitals INNER JOIN hospital_information ON hospitals.hospital_id=hospital_information.hospital_id;";
            ResultSet rs=st.executeQuery(sql);
        
%>
<table id="data" class="table table-hover">
    <tr>
        <th>
            Hospital ID
        </th>
        <th>
            Hospital Name
        </th>
        <th>
            Location
        </th>
        <th>
            Normal Beds
        </th>
        <th>
            Oxygen Beds
        </th>
        <th>
            ICU Beds
        </th>
        <th colspan="2">
            Actions
        </th>
    </tr>
    <%       while(rs.next()){
                String rn=rs.getInt(1);
                String na=rs.getString(2);
                String pe=rs.getString(3);
                String ad=rs.getString(4);
                String obed=rs.getString(5);
                String ibed=rs.getString(6);
    %>
    <form name="data">
    <tr>
        <td>
            <input type="text" name="id" id="id" value=" <%=rn%>" readonly>
        </td>
        <td>
            <input type="text" name="name" id="name" value=" <%=na%> ">
        </td>
        <td>
            <input type="text" name="location" id="location" value=" <%=pe%>">
        </td>
        <td>
            <input type="text" name="nbed" id="nbed" value=" <%=ad%>">
        </td>
        <td>
            <input type="text" name="obed" id="obed" value=" <%=obed%>">
        </td>
        <td>
            <input type="text" name="ibed" id="ibed" value=" <%=ibed%>">
        </td>
        <td>
            <input type="hidden" name="type" value="edit">
            <input type="submit" name="edit" onclick="sendInfo1()" value="edit">
        </td>
    </form>
    <form name="data1">
    <td>
            <input type="hidden" name="sid" value = "<%=rn%>">
            <input type="submit" name="delete" onclick="sendInfo2()" value="delete">
    </td>
    </tr>
    </form>
    </table>
    <%      }
        }
        catch(Exception e)
        {
            e.printStackTrace();
        } 

    
    
    
    
    %> 
  <% } %>



