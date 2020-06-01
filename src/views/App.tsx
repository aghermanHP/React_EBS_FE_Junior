import React from 'react';
import TableComponent from '../components/Table';
// import CartComponent from '../components/Cart';
import '../styles/styles.css';

export default class AppComponent extends React.Component {
  render() {
    // const TableComponent = (props: any) => ( <ItemComponent />)
    return (
      <div>
        <TableComponent />
      </div>
    );
  }
}
