import React from 'react';
import ReactBootstrap from 'react-bootstrap';
import ReactBootstrapSelect from 'react-bootstrap-select';
import DatePicker from 'react-bootstrap-date-picker';


import ReactDom from 'react-dom';
import { render } from 'react-dom'


const ShortList = require('./components/short_list').default;
//const App = require('./app');
document.addEventListener("DOMContentLoaded", function() {
  render(
    <ShortList/>
    , document.getElementById('react-start')
  );
});