import React from "react";
import { useQuery } from "@apollo/react-hooks";
import { gql } from "apollo-boost";

import { Button, Card } from "react-bootstrap";
import "bootstrap/dist/css/bootstrap.min.css";

const REGIONS = gql`
  {
    Region(orderBy: name_asc) {
      name
      children: subregions(orderBy: name_asc) {
        name
        children: countries(orderBy: name_asc) {
          name
        }
      }
    }
  }
`;

const App = () => {
  const { loading, error, data } = useQuery(REGIONS);
  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error :(</p>;

  return data.Region.map(({ name, children }) => {
    return (
      <>
        <Card style={{ width: "22rem" }}>
          <Card.Body>
            <Card.Title style={{ color: "green" }}>{name}</Card.Title>
            {children.map(({ name }) => {
              return (
                <Card.Subtitle className="mb-2 text-muted">
                  {name}
                </Card.Subtitle>
              )
            })}
          </Card.Body>
        </Card>
      </>
    );
  });
};

export default App;
