import java.io.PrintWriter;
import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.*;
import javax.servlet.*;

import org.json.simple.JSONArray;
import org.json.*;

public class LinkData extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String hash = request.getParameter("search");
            // System.out.println(hash);
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/covid", "root", "Gokul@2001");
            PreparedStatement st = null;
            String query = "select name,location,nbed,obed,ibed,cond1,cond2,cond3 from url2 where hash=?";
            st = con.prepareStatement(query);
            st.setString(1, hash);
            ResultSet rs = st.executeQuery();
            String name = "";
            String location = "";
            String nbed = "";
            String obed = "";
            String ibed = "";
            String cond1 = "";
            String cond2 = "";
            String cond3 = "";
            while (rs.next()) {
                name = rs.getString(1);
                location = rs.getString(2);
                nbed = rs.getString(3);
                obed = rs.getString(4);
                ibed = rs.getString(5);
                cond1 = rs.getString(6);
                cond2 = rs.getString(7);
                cond3 = rs.getString(8);
            }
            String name1 = name + "%";
            System.out.println(name1);
            // System.out.println(search);
            Statement st1 = con.createStatement();
            String sql = "";
            if (name.equals("null") && location.equals("null")) {
                sql = "select hospitals.hospital_id,hospital_information.Hospital_Name,hospitals.location,hospital_information.normal_bed,hospital_information.oxygen_bed,hospital_information.icu_bed FROM hospitals INNER JOIN hospital_information ON hospitals.hospital_id=hospital_information.hospital_id";
            } else {
                sql = "select hospitals.hospital_id,hospital_information.Hospital_Name,hospitals.location,hospital_information.normal_bed,hospital_information.oxygen_bed,hospital_information.icu_bed FROM hospitals INNER JOIN hospital_information ON hospitals.hospital_id=hospital_information.hospital_id where hospitals.Hospital_Name LIKE '"
                        + name1 + "'and hospitals.location= '" + location + "'and hospital_information.normal_bed"
                        + cond1 + "'" + nbed + "' and hospital_information.oxygen_bed" + cond2 + "'" + obed
                        + "'and hospital_information.icu_bed" + cond3 + "'" + ibed + "'";
            }
            System.out.println(sql);

            ResultSet rs1 = st1.executeQuery(sql);
            JSONObject json = new JSONObject();
            JSONArray arr = new JSONArray();
            int i = 1;
            while (rs1.next()) {
                JSONObject details = new JSONObject();
                details.put("type", "hospitals");
                details.put("id", i + "");
                JSONObject attributes = new JSONObject();
                i++;
                String rn = (rs1.getInt(1) + "");
                String na = rs1.getString(2);
                String pe = rs1.getString(3);
                String ad = rs1.getString(4);
                String oxbed = rs1.getString(5);
                String icbed = rs1.getString(6);
                attributes.put("hid", rn);
                attributes.put("hospital_name", na);
                attributes.put("location", pe);
                attributes.put("normal_beds", ad);
                attributes.put("oxygen_beds", oxbed);
                attributes.put("icu_beds", icbed);
                details.put("attributes", attributes);
                arr.add(details);
                i++;
            }
            json.put("data", arr);
            response.getWriter().write(json.toString());

        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (JSONException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
}
