using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MySql.Data.MySqlClient;

namespace Reflex_Project.Pages
{
    public class IndexModel : PageModel
    {

        private readonly string _connectionString;

        public IndexModel(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection"); 
        }

        public IActionResult OnPost()
        {
            string pseudo = Request.Form["pseudo"];
            string motDePasse = Request.Form["motDePasse"];
            string confirmerMotDePasse = Request.Form["confirmerMotDePasse"];

            if (motDePasse != confirmerMotDePasse)
            {
                return RedirectToPage("/welcome");
            }

            using (MySqlConnection connection = new MySqlConnection(_connectionString))
            {
                connection.Open();
                string query = "INSERT INTO db_reflex.t_users (username, password) VALUES (@username, @password)";
                using (MySqlCommand command = new MySqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@username", pseudo);
                    command.Parameters.AddWithValue("@password", motDePasse);
                    command.ExecuteNonQuery();
                }
            }
            Response.Cookies.Append("NomUtilisateur", pseudo);

            return RedirectToPage("/welcome"); 
        }
        public void OnGet()
        {
            
        }
    }
}