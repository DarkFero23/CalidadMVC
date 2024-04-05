using CapaEntidad;
using CapaNegocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace CapaPresentacionTienda.Controllers
{
    public class AccesoController : Controller
    {
        // GET: Acceso
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult Registrar()
        {
            return View();
        }
        public ActionResult Reestablecer()
        {
            return View();
        }
        public ActionResult CambiarClave()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Registrar(Cliente objeto)
        {
            int resultado;
            string mensaje = string.Empty;

            ViewData["Nombres"] = string.IsNullOrEmpty(objeto.Nombres) ? "" : objeto.Nombres;
            ViewData["Apellidos"] = string.IsNullOrEmpty(objeto.Apellidos) ? "" : objeto.Apellidos;
            ViewData["Correo"] = string.IsNullOrEmpty(objeto.Correo) ? "" : objeto.Correo;

            if (objeto.Clave != objeto.ConfirmarClave)
            {

                ViewBag.Error = "Las contraseñas no coinciden";
                return View();
            }


            resultado = new CN_Cliente().Registrar(objeto, out mensaje);

            if (resultado > 0)
            {
                ViewBag.Error = null;
                return RedirectToAction("Index", "Acceso");
            }
            else
            {
                ViewBag.Error = mensaje;
                return View();
            }

        }
        [HttpPost]
        public ActionResult Index(string correo, string clave)
        {
            Cliente oCliente = null;

            // Llamar al método de negocio para validar al usuario
            int idCliente;
            bool usuarioValido = new CN_Cliente().ValidarUsuario(correo, clave, out idCliente);

            if (!usuarioValido)
            {
                ViewBag.Error = "Correo o contraseña no son correctos";
                return View();
            }
            else
            {
                // Obtener los datos del usuario si la validación es exitosa
                oCliente = new CN_Cliente().ObtenerClientePorId(idCliente);

                if (oCliente == null)
                {
                    ViewBag.Error = "No se pudo obtener la información del cliente";
                    return View();
                }

                // Establecer el usuario en la sesión y redirigir a la página principal
                Session["Cliente"] = oCliente;
                ViewBag.Error = null;
                return RedirectToAction("Index", "Tienda");
            }
        }


        //[HttpPost]
        //public ActionResult Reestablecer(string correo)
        //{


        //    Cliente cliente = new Cliente();

        //    cliente = new CN_Cliente().Listar().Where(item => item.Correo == correo).FirstOrDefault();

        //    if (cliente == null)
        //    {
        //        ViewBag.Error = "No se encontro un cliente relacionado a ese correo";
        //        return View();
        //    }


        //    string mensaje = string.Empty;
        // bool respuesta = new CN_Cliente().ReestablecerClave(cliente.IdCliente, correo, out mensaje);

        //if (respuesta)
        //{

        //    ViewBag.Error = null;
        //    return RedirectToAction("Index", "Acceso");

        //}
        //else
        //{

        //    ViewBag.Error = mensaje;
        //    return View();
        //}


    }

   
}