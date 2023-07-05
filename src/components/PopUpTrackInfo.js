import React from 'react';
import PropTypes from "prop-types";
import PopupDialog from './PopupDialog.js';

export const PopUpTrackInfo = ({
  open,
  attributes,
  close,
}) => {
    return(
      <div>
        <PopupDialog open={open} close={close}>
            <h5>Object Information</h5>
            <table>
              {/* Node info here */}
              {(attributes || []).map(function(attribute){
                return <tr key={attribute[0]} style={{border: '1px solid black'}}>
                  <td style={{border: '1px solid black', fontWeight: 'bold'}}>{attribute[0]}</td>
                  <td>{attribute[1]}</td>
                </tr>;
              })}
            </table>
        </PopupDialog>
      </div>
    )
}


export default PopUpTrackInfo;

PopUpTrackInfo.propTypes = {
  open: PropTypes.bool.isRequired,
  /* array argument of track attribute pairs containing attribute name as a string and attribute value
  as a string or number */
  attributes: PropTypes.arrayOf(
    PropTypes.arrayOf(
      PropTypes.oneOfType([PropTypes.string, PropTypes.number])
    )
  ),
  close: PropTypes.func.isRequired,
}