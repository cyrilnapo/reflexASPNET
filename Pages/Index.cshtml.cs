using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MySql.Data.MySqlClient; // Assurez-vous d'importer ce namespace
using System;
using System.Threading.Tasks;

public class IndexModel : PageModel
{
    [BindProperty]
    public string DbIp { get; set; }
    public string ConnectionResult { get; set; }

    public void OnGet()
    {
    }

    public async Task<IActionResult> OnPostAsync()
    {
        if (string.IsNullOrEmpty(DbIp))
        {
            ConnectionResult = "Veuillez entrer une adresse IP.";
            return Page();
        }

        string connectionString = $"Server={DbIp};Database=mysql;User Id=root;Password=root;";
        try
        {
            using (MySqlConnection connection = new MySqlConnection(connectionString))
            {
                await connection.OpenAsync();
                ConnectionResult = "Connexion réussie.";
            }
        }
        catch (Exception ex)
        {
            ConnectionResult = $"Erreur de connexion : {ex.Message}";
        }

        return Page();
    }
}
