
import java.io.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.*;
import org.json.JSONObject;
import org.json.simple.JSONArray;

@WebServlet("/Search")

public class Search extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ServletInputStream mServletInputStream = request.getInputStream();
        byte[] httpinData = new byte[request.getContentLength()];
        int retVal = -1;

        StringBuilder stringBuilder = new StringBuilder();

        while ((retVal = mServletInputStream.read(httpinData)) != -1) {
            for (int i = 0; i < retVal; i++) {
                stringBuilder.append(Character.toString((char) httpinData[i]));
            }
        }
        String texts = stringBuilder.toString();

        try {
            JSONObject ob = new JSONObject(texts);
            System.out.println();
            System.out.println(ob.getJSONArray("data"));
            JSONObject data = (JSONObject) ob.getJSONArray("data").get(0);
            String name = data.getJSONObject("attributes").getString("hospital_name");
            String location = data.getJSONObject("attributes").getString("location");
            String nbed = data.getJSONObject("attributes").getString("normal_beds");
            String obed = data.getJSONObject("attributes").getString("oxygen_beds");
            String ibed = data.getJSONObject("attributes").getString("icu_beds");
            String cond1 = data.getJSONObject("attributes").getString("nbox");
            String cond2 = data.getJSONObject("attributes").getString("obox");
            String cond3 = data.getJSONObject("attributes").getString("ibox");

            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/covid", "root", "Gokul@2001");
            Statement st = con.createStatement();

            String sql = "";
            String name1 = name + "%";

            if (name.equals("") && location.equals("")) {
                sql = "select hospitals.hospital_id,hospital_information.Hospital_Name,hospitals.location,hospital_information.normal_bed,hospital_information.oxygen_bed,hospital_information.icu_bed FROM hospitals INNER JOIN hospital_information ON hospitals.hospital_id=hospital_information.hospital_id";
            } else {
                sql = "select hospitals.hospital_id,hospital_information.Hospital_Name,hospitals.location,hospital_information.normal_bed,hospital_information.oxygen_bed,hospital_information.icu_bed FROM hospitals INNER JOIN hospital_information ON hospitals.hospital_id=hospital_information.hospital_id where hospitals.Hospital_Name LIKE '"
                        + name1 + "'and hospitals.location= '" + location + "'and hospital_information.normal_bed"
                        + cond1 + "'" + nbed + "' and hospital_information.oxygen_bed" + cond2 + "'" + obed
                        + "'and hospital_information.icu_bed" + cond3 + "'" + ibed + "'";
            }
            System.out.println(sql);

            ResultSet rs = st.executeQuery(sql);
            JSONObject json = new JSONObject();
            JSONArray arr = new JSONArray();

            int i = 1;
            while (rs.next()) {
                JSONObject details = new JSONObject();
                details.put("type", "hospitals");
                details.put("id", i + "");
                JSONObject attributes = new JSONObject();
                i++;
                String rn = (rs.getInt(1) + "");
                String na = rs.getString(2);
                String pe = rs.getString(3);
                String ad = rs.getString(4);
                String oxbed = rs.getString(5);
                String icbed = rs.getString(6);
                attributes.put("hid", rn);
                attributes.put("hospital_name", na);
                attributes.put("location", pe);
                attributes.put("normal_beds", ad);
                attributes.put("oxygen_beds", oxbed);
                attributes.put("icu_beds", icbed);
                details.put("attributes", attributes);
                arr.add(details);
            }
            json.put("data", arr);
            response.getWriter().write(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}