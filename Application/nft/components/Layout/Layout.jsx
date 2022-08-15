import { Flex } from '@chakra-ui/react';
import Header from '../Header/Header';
import Footer from '../Footer/Footer';

const Layout = (props) => {
   return (
      <>
         <Flex
            w="100%"
            h="100%"
            minH="100vh"
            bgColor="f0f0f0"
            color="262626"
            fontFamily="Arial, sans-serif"
            flexDirection="column"
            AlignItems="stretch"
         >
            <Header>
            <Flex
               align="center"
               justify="center"
               flexDirection="column"
               w="100%"
               flex={1}         
            >
               {props.children}   
            </Flex>
            </Header> 
         </Flex>
      </>
   )
}

export default Layout;