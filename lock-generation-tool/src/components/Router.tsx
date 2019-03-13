import * as React from 'react';
import { BrowserRouter, Route, Switch } from 'react-router-dom';
import Home from '../containers/Home';
import { Routes } from '../utils/const';

export default () => {
  return(
    <BrowserRouter>
      <Switch>
        <Route path={Routes.Home} comment={Home}/>
      </Switch>
    </BrowserRouter>
  )
}