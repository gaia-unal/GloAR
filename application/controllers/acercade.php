<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Acercade extends CI_Controller {


	public function index()
	{
                $contenido = array(
                    'titulo' => 'Acerca de',
                    'main'   => 'acercade_view',
                    'label'  => 'acercade'
                );
		$this->load->view('include/template1',$contenido);
	}
}
