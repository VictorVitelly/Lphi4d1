program main
    use iso_fortran_env, only : dp => real64, i4 => int32
    implicit none

    integer(i4), parameter :: N=16,thermalization=1000,eachsweep=80,Nmsrs=200,Nmsrs2=120
    integer(i4), parameter :: Nps=11, Mbin(4)=(/5,10,15,20/)
    real(dp) :: phi(N),dphi=0.5_dp,AR,m0,lambda0=1._dp
    integer(i4) :: i,i1,j,k
    real(dp) :: magnet(Nmsrs2),action(Nmsrs2),arate(Nmsrs2)
    real(dp) :: magnet_ave,magnet_err,action_ave,action_err,arate_ave,arate_err
    open(10, file = 'data/history.dat', status = 'replace')
    open(20, file = 'data/action.dat', status = 'replace')
    open(30, file = 'data/magnet.dat', status = 'replace')
    do k=1,Nps
      phi(:)=0._dp
      arate(:)=0._dp
      action(:)=0._dp
      magnet(:)=0._dp
      m0=-3.0_dp*real(k-1,dp)/real(Nps-1,dp)
      do i=1,thermalization
          call montecarlo(m0,dphi,phi,AR)
          write(10,*) i, S(m0,phi)
      end do
      do i=1,Nmsrs2
        do i1=1,Nmsrs
          do j=1,eachsweep
            call montecarlo(m0,dphi,phi,AR)
          end do
          arate(i)=arate(i)+AR
          action(i)=action(i)+S(m0,phi)
          magnet(i)=magnet(i)+abs(mean(phi))
        end do
      end do
      arate(:)=arate(:)/real(Nmsrs,dp)
      action(:)=action(:)/real(Nmsrs,dp)
      magnet(:)=magnet(:)/real(Nmsrs,dp)

      call mean_scalar(arate,arate_ave,arate_err)
      call mean_scalar(action,action_ave,action_err)
      call mean_scalar(magnet,magnet_ave,magnet_err)
      write(*,*) m0,arate_ave,arate_err
      write(20,*) m0,action_ave/real(N,dp), action_err/real(N,dp)
      write(30,*) m0,magnet_ave/real(N,dp), magnet_err/real(N,dp)
    end do
    close(10)
    close(20)
    close(30)

    call correlate(0._dp,-3.0_dp,11)

contains

  function iv(i)
    integer(i4), intent(in) :: i
    integer(i4) :: iv
    if(i==N+1) then
      iv=1
    else if(i==0) then
      iv=N
    else
      iv=i
    end if
  end function

  function lagrangian(m02,phi,i1)
    real(dp), intent(in) :: m02
    real(dp), dimension(:), intent(in) :: phi
    integer(i4), intent(in) :: i1
    real(dp) :: lagrangian
    lagrangian=( (phi(iv(i1+1))-phi(i1) )**2  &
              &+m02*phi(i1)**2 +lambda0*phi(i1)**4 /2._dp )/2._dp
  end function lagrangian

  function S(m02,phi)
    real(dp), intent(in) :: m02
    real(dp), dimension(:), intent(in) :: phi
    real(dp) :: S
    integer(i4) :: i1,Narr
    Narr=size(phi,dim=1)
    S=0._dp
    do i1=1,Narr
        S=S+lagrangian(m02,phi,i1)
    end do
  end function S

  function DeltaS(m02,phi,i1,phi2)
    real(dp), intent(in) :: m02
    real(dp), dimension(:), intent(in) :: phi
    integer(i4), intent(in) :: i1
    real(dp), intent(in) :: phi2
    real(dp) :: DeltaS
    real(dp) :: DSa,DSb
    DSa=(1._dp+m02/2._dp )*(phi2**2-phi(i1)**2 )+lambda0*(phi2**4-phi(i1)**4)/4._dp
    DSb=-(phi2-phi(i1))*(phi(iv(i1+1))+phi(iv(i1-1)))
    DeltaS=DSa +DSb
  end function DeltaS

  function mean(phi)
    real(dp), dimension(:), intent(in) :: phi
    integer(i4):: i1,Narr
    real(dp) :: mean
    Narr=size(phi,dim=1)
    mean=0._dp
    do i1=1,Narr
        mean=mean+phi(i1)
    end do
  end function mean

  subroutine random_phi(x,bound)
    real(dp),intent(out) :: x
    real(dp), intent(in) :: bound
    real(dp) :: y
    call random_number(y)
    x = 2._dp*bound*y -bound
  end subroutine random_phi

  subroutine montecarlo(m0,dphi,phi,AR)
    real(dp), intent(in) :: m0,dphi
    real(dp), dimension(N), intent(inout) :: phi
    real(dp), intent(out) :: AR
    real(dp) :: deltaphi,phi2,DS,r,p
    integer(i4) :: i1,i2
    AR=0._dp
    do i1=1,N
        call random_phi(deltaphi,dphi)
        phi2=phi(i1)+deltaphi
        DS=DeltaS(m0,phi,i1,phi2)
        if(DS .le. 0._dp) then
          phi(i1)=phi2
          AR=AR+1._dp
        else
          call random_number(r)
          p=Exp(-DS)
          AR=AR+p
          if(r < p ) then
            phi(i1)=phi2
          end if
        end if
    end do
    AR=AR/real(N,dp)
  end subroutine montecarlo

  subroutine standard_error(x,y,deltay)
    real(dp), dimension(:), intent(in) :: x
    real(dp), intent(in) :: y
    real(dp), intent(out) :: deltay
    real(dp) :: variance
    integer(i4) :: k,Narr
    Narr=size(x)
    deltay=0._dp
    variance=0._dp
    do k=1,Narr
      variance=variance+(x(k) -y)**2
    end do
    variance=variance/real(Narr-1,dp)
    deltay=Sqrt(variance/real(Narr,dp))
  end subroutine standard_error

  subroutine jackknife(x,y,deltay)
    real(dp), dimension(:), intent(in) :: x
    real(dp), intent(in) :: y
    real(dp), intent(out) :: deltay
    real(dp) :: jackk
    real(dp), allocatable :: xmean(:), delta_y(:)
    integer(i4) :: k,Narr,i,j
      Narr=size(x)
      allocate(delta_y(size(Mbin)))
      do j=1,size(Mbin)
        allocate(xmean(Mbin(j)))
        jackk=0._dp
        xmean=0._dp
        do i=1,Mbin(j)
          do k=1,Narr
            if(k .le. (i-1)*Narr/Mbin(j)) then
              xmean(i)=xmean(i)+x(k)
            else if(k > i*Narr/Mbin(j)) then
              xmean(i)=xmean(i)+x(k)
            end if
          end do
          xmean(i)=xmean(i)/(real(Narr,dp) -real(Narr/Mbin(j),dp))
        end do
        do k=1,Mbin(j)
          jackk=jackk+(xmean(k)-y )**2
        end do
        delta_y(j)=Sqrt(real(Mbin(j)-1,dp)*jackk/real(Mbin(j),dp))
        deallocate(xmean)
      end do
      deltay=maxval(delta_y)
  end subroutine jackknife

  subroutine mean_0(x,y)
    real(dp), dimension(:), intent(in) :: x
    real(dp), intent(out) :: y
    integer(i4) :: k,Narr
    Narr=size(x)
    y=0._dp
    do k=1,Narr
      y=y+x(k)
    end do
    y=y/real(Narr,dp)
  end subroutine mean_0

  subroutine mean_scalar(x,y,deltay)
    real(dp), dimension(:), intent(in) :: x
    real(dp), intent(out) :: y,deltay
    integer(i4) :: k
    call mean_0(x,y)
    !call standard_error(x,y,deltay)
    call jackknife(x,y,deltay)
  end subroutine mean_scalar

  subroutine correlation(phi,corr1,corr2)
    real(dp), dimension(N), intent(in) :: phi
    real(dp), dimension(N), intent(inout) :: corr1
    real(dp), dimension(N,N), intent(inout) :: corr2
    real(dp) :: xx
    integer(i4) :: i1,i2
    do i1=1,N
      corr1(i1)=corr1(i1)+abs(phi(i1))
      do i2=1,N
        corr2(i1,i2)=corr2(i1,i2)+(phi(i1)*phi(i2))
      end do
    end do
  end subroutine correlation

  subroutine correlate(mi,mf,Nts)
  real(dp), intent(in) :: mi,mf
  real(dp) :: m0,dphi,AR
  integer(i4) :: Nts
  real(dp), allocatable :: phi(:),corr1(:),corr2(:,:),CF(:,:),CF_ave(:,:),CF_delta(:,:)
  integer(i4) :: i,j,k,i2
  open(60, file = 'data/corrfunc.dat', status = 'replace')
  allocate(phi(N))
  allocate(corr1(N))
  allocate(corr2(N,N))
  allocate(CF(N,Nmsrs2))
  allocate(CF_ave(N,Nts))
  allocate(CF_delta(N,Nts))

  do k=1,Nts
    CF(:,:)=0._dp
    m0=mi+(mf-mi)*real(k-1,dp)/real(Nts-1,dp)
    !dphi=0.45_dp +x0/30._dp
    !x0=lambi+(lambf-lambi)*real(k-1,dp)/real(Nts-1,dp)
    write(*,*) m0
    phi(:)=0._dp
    do j=1,thermalization
      call montecarlo(m0,0.5_dp,phi,AR)
    end do
    do j=1,Nmsrs2
      corr1(:)=0._dp
      corr2(:,:)=0._dp
      do i=1,Nmsrs
        do i2=1,eachsweep
          call montecarlo(m0,0.5_dp,phi,AR)
        end do
        call correlation(phi,corr1,corr2)
      end do
      corr1(:)=corr1(:)/real(Nmsrs,dp)
      corr2(:,:)=corr2(:,:)/real(Nmsrs,dp)
      do i=1,N
        CF(i,j)=corr2(i,1) !-(corr1(1)**2)
      end do
    end do
    do j=1,N
      call mean_scalar(CF(j,:),CF_ave(j,k),CF_delta(j,k))
    end do
  end do

  do k=1,N+1
    write(60,*) abs(k-1), CF_ave(iv(k),:), CF_delta(iv(k),:)
  end do

  deallocate(corr1,corr2,CF,CF_ave,CF_delta)
  deallocate(phi)
  close(60)
  end subroutine correlate

end program main
