<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Apps extends CI_Controller {


	public function index()
	{
                $contenido = array(
                    'titulo' => 'Aplicaciones',
                    'main'   => 'apps_view',
                    'label'  => 'apps'
                );
		$this->load->view('include/template1',$contenido);
	}
}
