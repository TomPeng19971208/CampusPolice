import React, { Component } from 'react';
import {
  OpsContainer,
  UserWrapper,
  IncidentsWrapper,
  ActionsWrapper,
} from './styled-components/operationStyles';
import UserSession from './userSession';
import axios from 'axios';
import { apiUrl } from './constant';
import ReportButton from './reportButton';
import EmergencyButton from './emergencyButton';

class Operation extends Component {
  reportCrime() {
    const payLoad = {

    }
    axios.post(apiUrl + records)
      .then((response))
  }

  checkboxToNumber(list) {
    list.filter((item) => {
      item.isChecked
    })
  }

  render() {
    return (
      <OpsContainer>
        <UserWrapper>
          <UserSession />
        </UserWrapper>
        <IncidentsWrapper>
          <p>
            dd
          </p>
          <p>
            dd
          </p>
          <p>
            dd
          </p>
          <p>
            dd
          </p>
          <p>
            dd
          </p>
        </IncidentsWrapper>
        <ActionsWrapper>
          <ReportButton />
          <EmergencyButton />
        </ActionsWrapper>
      </OpsContainer>
    );
  }
}

export default Operation;