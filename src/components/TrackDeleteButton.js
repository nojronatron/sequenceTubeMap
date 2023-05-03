import React from "react";
import { Button } from "reactstrap";
import { faX } from '@fortawesome/free-solid-svg-icons';
import PropTypes from "prop-types";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";

/**
 * A track delete button component.
 * 
 * When clicked, would call a function to delete the track
 * 
 */

 export function TrackDeleteButton (props) {

    // return button
    // upon click, call onClick function 
    
    return (
        <Button data-testid="delete-button" {...props}><FontAwesomeIcon icon={faX} /></Button>
    );
}

/* React checks for the type of each prop passed in to ensure that the correct type is being 
inputted to the component. For example, if 'id' is supposed to be a string, a number must not 
be passed in - that would cause errors. However, if the prop has 'isRequired' specified, 
it must be passed to the component. */

TrackDeleteButton.propTypes = {
  id: PropTypes.string,
  className: PropTypes.string,
  onClick: PropTypes.func.isRequired,
};

TrackDeleteButton.defaultProps = {
  id: undefined,
  className: undefined,
};

export default TrackDeleteButton;
