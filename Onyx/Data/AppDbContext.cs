﻿using System.Data;
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
            string UserId = "absluser";
            string Password = "0c4gn2zn";
            _connectionString = string.Format(_configuration.GetConnectionString("OnyxDb"), UserId, Password);
        }
        public IDbConnection CreateConnection() => new SqlConnection(_connectionString);
    }
}
