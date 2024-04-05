using CapaDatos;
using CapaEntidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class CN_Cliente
    {
        private CD_Cliente objCapaDato = new CD_Cliente();


        public int Registrar(Cliente obj, out string Mensaje)
        {

            Mensaje = string.Empty;


            if (string.IsNullOrEmpty(obj.Nombres) || string.IsNullOrWhiteSpace(obj.Nombres))
            {
                Mensaje = "El nombre del cliente no puede ser vacio";
            }
            else if (string.IsNullOrEmpty(obj.Apellidos) || string.IsNullOrWhiteSpace(obj.Apellidos))
            {
                Mensaje = "El apellido del cliente no puede ser vacio";
            }
            else if (string.IsNullOrEmpty(obj.Correo) || string.IsNullOrWhiteSpace(obj.Correo))
            {
                Mensaje = "El correo del cliente no puede ser vacio";
            }


            if (string.IsNullOrEmpty(Mensaje))
            {
                return objCapaDato.Registrar(obj, out Mensaje);


            }
            else
            {

                return 0;
            }
        }




           

            public List<Cliente> Listar()
            {
                return objCapaDato.Listar();
            }
        public Cliente ObtenerUsuario(string correo, string clave)
        {
            return Listar().Where(item => item.Correo == correo && item.Clave == clave).SingleOrDefault();
        }
        public bool ValidarUsuario(string correo, string clave, out int idCliente)
        {
            idCliente = 0;
            return objCapaDato.ValidarUsuario(correo, clave, out idCliente);
        }
        public Cliente ObtenerClientePorId(int idCliente)
        {
            // Llama al método correspondiente en la capa de datos para obtener el cliente por su ID
            return objCapaDato.ObtenerClientePorId(idCliente);
        }
    }
            


        //public bool CambiarClave(int idcliente, string nuevaclave, out string Mensaje)
        //{

        //    return objCapaDato.CambiarClave(idcliente, nuevaclave, out Mensaje);
        //}


        //public bool ReestablecerClave(int idcliente, string correo, out string Mensaje)
        //{
        //    Mensaje = string.Empty;

        //    // Obtener la contraseña actual del cliente de la base de datos
        //    Cliente cliente = objCapaDato.Listar().FirstOrDefault(c => c.IdCliente == idcliente);

        //    if (cliente == null)
        //    {
        //        Mensaje = "No se encontró un cliente relacionado con ese ID";
        //        return false;
        //    }

        //    // Utilizar la contraseña existente del cliente sin cambiarla
        //    bool resultado = objCapaDato.ReestablecerClave(idcliente, cliente.Clave, out Mensaje);

        //    if (resultado)
        //    {
        //        // Envía el correo con la contraseña existente
        //        string asunto = "Contraseña Restablecida";
        //        string mensaje_correo = "<h3>Su cuenta fue restablecida correctamente</h3></br><p>Su contraseña para acceder ahora es: " + cliente.Clave + "</p>";

        //        bool respuesta = CN_Recursos.EnviarCorreo(correo, asunto, mensaje_correo);

        //        if (respuesta)
        //        {
        //            return true;
        //        }
        //        else
        //        {
        //            Mensaje = "No se pudo enviar el correo";
        //            return false;
        //        }
        //    }
        //    else
        //    {
        //        Mensaje = "No se pudo restablecer la contraseña";
        //        return false;
        //    }
    }


 

