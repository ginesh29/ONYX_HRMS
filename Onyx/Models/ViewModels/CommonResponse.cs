﻿namespace Onyx.Models.ViewModels
{
    public class CommonResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public string RedirectUrl { get; set; }
        public dynamic Data { get; set; }
    }
}
