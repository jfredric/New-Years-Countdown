using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;

namespace ElevenHealth.TimezoneApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TimezoneController : ControllerBase
    {
        private readonly IHttpClientFactory _httpClientFactory;
        private static IDictionary<string, string> _cache = new Dictionary<string, string>();

        public TimezoneController(IHttpClientFactory httpClientFactory)
        {
            _httpClientFactory = httpClientFactory ?? throw new ArgumentNullException(nameof(httpClientFactory));
        }

        // GET api/timezone/90210
        [HttpGet("{id}")]
        public async Task<IActionResult> Get(string id)
        {
            var applicationKey = GetApplicationKey();

            if (applicationKey != "b064b6d2-8fbd-48b0-ac29-1a88237ce022")
            {
                return Unauthorized("Invalid application key");
            }

            if (!_cache.Keys.Contains(id))
            {
                var url = $"https://www.zipcodeapi.com/rest/cZaEwkKSEPgIbNPBWKygIbAGlFeLZ0OIOZXuiApmr2J0EDdaSMYaH3wnK2iUYzft/info.json/{id}/degrees";

                var httpClient = _httpClientFactory.CreateClient();

                var clientReponse = await httpClient.GetAsync(url);

                _cache[id] = await clientReponse.Content.ReadAsStringAsync();
            }

            return Ok(JObject.Parse(_cache[id]));
        }

        private string GetApplicationKey()
        {
            return Request.Headers["X-Application-Key"];
        }
    }
}
