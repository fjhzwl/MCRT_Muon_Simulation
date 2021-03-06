      subroutine gridset(xface,yface,zface,rhokap,xmax,ymax,zmax,
     +                  kappa,znumber)

      implicit none

      include 'grid.txt'

      real*8 xmax,ymax,zmax,kappa

      integer i,j,k,Za
      real*8 x,y,z,rho,taueq,taupole
      

      print *, 'Setting up density grid....'

c**********  Linear Cartesian grid. Set up grid faces ****************
      do i=1,nxg+1
         xface(i)=(i-1)*2.*xmax/nxg
      end do
      do i=1,nyg+1
         yface(i)=(i-1)*2.*ymax/nyg
      end do
      do i=1,nzg+1
         zface(i)=(i-1)*2.*zmax/nzg
      end do

c**************  Loop through x, y, and z to set up grid density.  ****
      do i=1,nxg
       do j=1,nyg
        do k=1,nzg
           x=xface(i)-xmax+xmax/nxg
           y=yface(j)-ymax+ymax/nyg
           z=zface(k)-zmax+zmax/nzg

c**********************Call density setup subroutine 
           call density(x,y,z,rho,Za)
           rhokap(i,j,k)=rho*kappa
           znumber(i,j,k)=Za
           
            

        end do
       end do
      end do

c****************** Calculate equatorial and polar optical depths ****
      taueq=0.
      taupole=0.
      do i=1,nxg
         taueq=taueq+rhokap(i,nyg/2,nzg/2)
      enddo
      do i=1,nzg
         taupole=taupole+rhokap(nxg/2,nyg/2,i)
      enddo
      taueq=taueq*2.*xmax/nxg
      taupole=taupole*2.*zmax/nzg
      print *,'taueq = ',taueq,'  taupole = ',taupole
      
c************** Write out density grid as unformatted array
      open(10,file='density.dat',status='unknown',
     +        form='unformatted')
           write(10) rhokap
      close(10)
      
      open(10,file='slice.dat',status='unknown')
      
      do i=1,nxg
        write(10,*) (rhokap(i,j,10), j=1,nyg)
      end do
      
c      do i=1,nxg
c       do j=1,nyg
c           x=xface(i)-xmax+xmax/nxg
c           y=yface(j)-ymax+ymax/nyg
c         write(10,*) x,y,rhokap(i,j,101)
c          
c       end do
c      end do 

      return
      end
