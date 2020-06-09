<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Contacto extends CI_Controller {


	public function index()
	{
                $contenido = array(
                    'titulo' => 'Contacto',
                    'main'   => 'contacto_view',
                    'label'  => 'contacto'
                );
		$this->load->view('include/template1',$contenido);
	}
}
