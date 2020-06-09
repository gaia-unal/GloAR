<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Inicio extends CI_Controller {


	public function index()
	{
                $contenido = array(
                    'titulo' => 'Inicio',
                    'main'   => 'inicio_view',
                    'label'  => 'inicio'
                );
		$this->load->view('include/template1',$contenido);
	}

    public function marker(){
        $this->load->view("marker.php");
    }
}
