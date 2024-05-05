using System.Data;
using System.Data.SqlClient;

namespace Onyx.Data
{
    public class AppDbContext
    {
        private readonly string _connectionString;
        public AppDbContext()
        {
            _connectionString = "Server=GINESH-PC\\SQLEXPRESS;Initial catalog=dbGateway;uid=absluser; pwd=0c4gn2zn;TrustServerCertificate=True;Connection Timeout=120;";
        }
        public IDbConnection CreateConnection() => new SqlConnection(_connectionString);
    }
}
