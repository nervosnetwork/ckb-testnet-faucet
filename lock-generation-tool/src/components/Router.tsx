import * as React from 'react';
import { BrowserRouter, Route, Switch } from 'react-router-dom';
import Home from '../containers/Home';
import { Routes } from '../utils/const';
import NewLock from '../containers/NewLock';

export default () => {
  return(
    <BrowserRouter>
      <Switch>
        <Route path={Routes.NewLock} component={NewLock}/>
        <Route path={Routes.Home} component={Home}/>
      </Switch>
    </BrowserRouter>
  )
}