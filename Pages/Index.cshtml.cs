using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Data.SqlClient;
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
            using (SqlConnection connection = new SqlConnection(connectionString))
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
