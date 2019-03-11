import * as React from 'react';
import { BrowserRouter, Route, Switch } from 'react-router-dom';
import Authorization from '../containers/Authorization';
import Failure from '../containers/Failure';
import Home from '../containers/Home';
import Success from '../containers/Success';
import ServiceError from '../containers/ServiceError';
import { Routes } from '../utils/const'

export default () => {
  return (
    <BrowserRouter>
      <Switch>
        <Route path={Routes.Auth} component={Authorization} />
        <Route path={Routes.Success} component={Success} />
        <Route path={Routes.Failure} component={Failure} />
        <Route path={Routes.ServiceError} component={ServiceError} />
        <Route path={Routes.Home} component={Home} />
      </Switch>
    </BrowserRouter>
  )
}
