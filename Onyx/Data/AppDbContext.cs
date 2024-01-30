using System.Data;
using System.Data.SqlClient;

namespace Onyx.Data
{
    public class AppDbContext
    {
        private readonly IConfiguration _configuration;
        private readonly string _connectionString;
        public AppDbContext(IConfiguration configuration)
        {
            _configuration = configuration;
            _connectionString = _configuration.GetConnectionString("OnyxDb");
        }
        public IDbConnection CreateConnection() => new SqlConnection(_connectionString);
    }
}
