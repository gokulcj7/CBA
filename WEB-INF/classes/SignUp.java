import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;

@WebServlet("/SignUp")
public class SignUp extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		response.setContentType("text/html");
		PrintWriter out = response.getWriter();

		try {
			Connection con = null;

			PreparedStatement st = null;
			con = DriverManager.getConnection("jdbc:mysql://localhost/covid", "root", "Gokul@2001");

			String query = "insert into user(Name,Gender,Blood_Group,State,Address,email,password) values(?,?,?,?,?,?,?)";

			st = con.prepareStatement(query);

			String name = request.getParameter("1");
			String Gender = request.getParameter("2");
			String Blood = request.getParameter("3");
			String State = request.getParameter("4");
			String Address = request.getParameter("5");
			String Email = request.getParameter("6");
			String Password = request.getParameter("7");

			st.setString(1, name);
			st.setString(2, Gender);
			st.setString(3, Blood);
			st.setString(4, State);
			st.setString(5, Address);
			st.setString(6, Email);
			st.setString(7, Password);

			int n = st.executeUpdate();

			if (n > 0) {
				out.print("<script>alert('Account Created sucessfully')</script>");
				request.getRequestDispatcher("index1.jsp").include(request, response);
			} else {
				out.print("<p>Failed to create Account<p>");
				request.getRequestDispatcher("signup.html").include(request, response);
			}

			st.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
		out.close();
	}
}