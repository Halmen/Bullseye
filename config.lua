-- config.lua

application =
{	
    content =
    {
        fps = 60,
        width = 320,
        height = 480,
        scale = "letterbox",
        antialias = true,
        imageSuffix =
        {
          ["@4x"] = 4,
        	  ["@2x"] = 2
        },

    },
	notification =
	{
	    iphone =
	    {
	        types =
	        {
	           "badge", "sound", "alert"
	        }
	    },
	},
    license =
    {
        google =
        {
            key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvD20ZuP/xsA919NI9jfLKw5tyS2yXzs2+WjPAy4+Ih/lh92HwuNYB43IVzzqVhAciSxEieFigI4AIl8HlQQWp6VNh4Jh4U4OnUWMO8S7hgI4bY7+5bTeo9jC+X1rx6IzPCF4OnLpaxHt3ShRIY0CIq43bQrnT1ESBV0v9qnSGoK18KF1xi3eAci2vM7GpGehMEOtw1pUictgbc5EI97lexJOvwln4W1nSjRgTe8Cr6Oc/57Bwx9bxgIXzwv7jO73tknSvSzoOEKjZ8iQBE8EVlZXjKpEFTz+AjhLA1oIzEH6/YERFpV+EAQiS4qJfmWjq7Yh+PVlOE02smyecyT/dQIDAQAB",
        },
    }
}